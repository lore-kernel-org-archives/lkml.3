Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab3H0Gmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:42:37 -0400
Received: from 19.mo1.mail-out.ovh.net ([178.32.97.206]:48363 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752569Ab3H0Gmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:42:35 -0400
Message-ID: <521C49EF.5020403@overkiz.com>
Date: Tue, 27 Aug 2013 08:40:47 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH 2/3] pinctrl: at91: add support for generic pinconf
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380259-11290-1-git-send-email-b.brezillon@overkiz.com> <521B8822.50304@wwwdotorg.org> <521B8D9B.5020809@overkiz.com> <521C23AF.2060309@wwwdotorg.org>
In-Reply-To: <521C23AF.2060309@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5330010160311072845
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2013 05:57, Stephen Warren wrote:
> On 08/26/2013 11:17 AM, boris brezillon wrote:
>> On 26/08/2013 18:53, Stephen Warren wrote:
>>> On 08/24/2013 03:37 PM, Boris BREZILLON wrote:
>>>> Add support for generic pin configuration to pinctrl-at91 driver.
>>>> diff --git
>>>> a/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>> b/Documentation/devicetree/bindings/pinctrl/atmel,at91-pinctrl.txt
>>>>    Required properties for iomux controller:
>>>> -- compatible: "atmel,at91rm9200-pinctrl"
>>>> +- compatible: "atmel,at91rm9200-pinctrl" or "atmel,at91sam9x5-pinctrl".
>>> You seem to also be adding a second chip name to the list here, which is
>>> more than the patch subject/description imply you're doing...
>> This is an update of the documentation:
>> "atmel,at91sam9x5-pinctrl" compatible is already used in the pinctrl
>> driver but the documention
>> was not updated.
>>
>> But I agree, this should not be part of this series.
>>
>>>> +  Add "generic-pinconf" to the compatible string list to use the
>>>> generic pin
>>>> +  configuration syntax.
>>> "generic-pinconf" is too generic of a compatible value for this binding
>>> to define.
>>>
>>> Instead, I think you want to either:
>>>
>>> a)
>>>
>>> Use compatible="atmel,at91rm9200-pinctrl" for the old binding,
>>> use compatible="atmel,at91rm9200-pinctrl-generic" for the new binding
>>>
>>> or:
>>>
>>> b)
>>>
>>> Define Boolean property atmel,generic-pinconf (perhaps a better name
>>> could be chosen?). If it's not present, parse the node assuming the old
>>> binding. If it is present, parse the node assuming the new binding.
>>>
>> Okay.
>>
>> I thought this property string could be generic as it may concern other
>> drivers too
>> (in order to keep compatibility with old dt ABI and add support the
>> generic pinconf binding).
>>
>> Anyway, I prefer the first proposition.
>>
>> pinctrl single driver is already using these names:
>>
>> |compatible = "pinctrl-single" for non generic pinconf binding
>> ||compatible = "pinconf-single" ||for generic pinconf binding|
>>
>> So I think we should use something similar:
>>
>> |compatible = "atmel,at91xx-pinctrl" for non generic pinconf binding
>> ||compatible = "|||atmel,at91xx-|pinconf" ||for generic pinconf binding|
>>
>> What do you think ?
> Hmmm. It is a little odd to switch out the compatible value and invent a
> new binding for the same HW. Isn't it possible to define both sets of
> properties in the binding, and have drivers look for either?
>

Do you mean something like:

atmel,pins = <xxx>;                /* current dt binding */
atmel,generic-pins = <yyy>;    /* new dt binding */

If that's what you had in mind, it will be a little bit tricky to 
handle, because AFAIK the pinconf_ops
callbacks do not give me any element I could use to deduce the type of 
pinconf (generic or
native).
This implies I have to know early during the probe process which kind of 
binding is in use.

Please tell me if I missed some key points, and this can be easily done.


