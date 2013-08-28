Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3H1Mxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 08:53:55 -0400
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:40637 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249Ab3H1Mxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 08:53:53 -0400
Message-ID: <521DF278.3090307@overkiz.com>
Date: Wed, 28 Aug 2013 14:52:08 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC PATCH 3/3] ARM: at91/dt: move sama5 to generic pinconf
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380400-11331-1-git-send-email-b.brezillon@overkiz.com> <CACRpkdbGWAg19Redc-KB4=dUnNOqCVvFN4H=wAAoki6Y=Zp-wA@mail.gmail.com>
In-Reply-To: <CACRpkdbGWAg19Redc-KB4=dUnNOqCVvFN4H=wAAoki6Y=Zp-wA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17471996230072760541
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On 28/08/2013 14:28, Linus Walleij wrote:
> On Sat, Aug 24, 2013 at 11:40 PM, Boris BREZILLON
> <b.brezillon@overkiz.com> wrote:
>
>> Add generic pinconf definitions and reference appropriate configs in
>> atmel,pins properties.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> (...)
>>                          pinctrl@fffff200 {
>>                                  #address-cells = <1>;
>>                                  #size-cells = <1>;
>> -                               compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "simple-bus";
>> +                               compatible = "atmel,at91sam9x5-pinctrl", "atmel,at91rm9200-pinctrl", "generic-pinconf", "simple-bus";
> What kind of compatible string is that "generic-pinconf"?
>
> There is no driver that can instantiate against this string but I'm not
> 100% sure about such things. Is there some other driver doing this?
>
> Else I think it'd just be removed.

It did not exist before this patch series.

I thought it would be good idea to add a compatible string to tell if 
the pinctrl subnodes support the generic-pinconf binding,
without modifying the current compatible strings:
if compatible string contains the "generic-pinconf" then the pinconf 
definitions should be considered generic.

However, after discussing it with Stephen, Jean-Christophe and Nicolas, 
I no longer think this is a good idea
(backward compatibility issues).



>
>> +                               pcfg_none: pcfg_none {
>> +                                       bias-disable;
>> +                               };
>> +
>> +                               pcfg_pull_up: pcfg_pull_up {
>> +                                       bias-pull-up;
>> +                               };
> Nice.
>
>> +                               pcfg_deglitch: pcfg_deglitch {
>> +                                       input-deglitch = <1>;
>> +                               };
>> +
>> +                               pcfg_pull_up_deglitch: pcfg_pull_up_deglitch {
>> +                                       bias-pull-up;
>> +                                       input-deglitch = <1>;
>> +                               };
> input-deglitch seems like a proposed generic binding but I haven't seen
> these yet?
> (It might be in my violently exploding INBOX though sorry in that case.)
>
> This would need adding to
> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> Plus changes to pinctrl core for handling.

This was added in the first patch of this series:
https://lkml.org/lkml/2013/8/24/99

> BTW: this is really moving in the right direction!
>
> Yours,
> Linus Walleij

Thanks.

Best Regards,

Boris
