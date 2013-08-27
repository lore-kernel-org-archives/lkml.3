Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3H0G0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:26:09 -0400
Received: from 5.mo1.mail-out.ovh.net ([178.33.45.107]:54776 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752349Ab3H0G0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:26:08 -0400
Message-ID: <521C4451.1060908@overkiz.com>
Date: Tue, 27 Aug 2013 08:16:49 +0200
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
Subject: Re: [RFC PATCH 1/3] pinctrl: add new generic pinconf config for deglitch
 filter
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380109-11247-1-git-send-email-b.brezillon@overkiz.com> <521B875E.1010605@wwwdotorg.org> <521B89D1.6010902@overkiz.com> <521C2347.4080702@wwwdotorg.org>
In-Reply-To: <521C2347.4080702@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4925249143003510861
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.500073/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2013 05:55, Stephen Warren wrote:
> On 08/26/2013 11:01 AM, boris brezillon wrote:
>> Hello Stephen,
>>
>> On 26/08/2013 18:50, Stephen Warren wrote:
>>> On 08/24/2013 03:35 PM, Boris BREZILLON wrote:
>>>> Add a new parameter to support deglitch filter configuration.
>>>> A deglitch filter works like a debounce filter but with a smaller
>>>> delay (nanoseconds).
>>> Why not use the existing debounce property, just with a small delay
>>> specified. It seems like that's exactly what the property is for?
>> That's one of the question I asked in my cover letter :-)
>>
>> Indeed the at91 deglitch filter delay is not configurable and is statically
>> assigned to half a master clk cycle (if master clk = 133MHz -> 8 ns).
>> The debounce property argument is currently expressed in usecs.
>>
>> This will result in always selecting the debounce filter (which is also
>> available on at91 SoCs) over the deglitch filter.
>>
>> Could we add a flag in the deglitch argument to specify the delay unit
>> (nsecs or usecs) ?
> If the value is hard-coded in HW, why not use non-zero (or 1) to enable
> and zero to disable?

Indeed at91 pins support both deglitch and debounce filter and I have to 
choose
between the two given the argument value (in usec).

Here's what I can do:

if (arg >= 1/2 * slowclock)    /* debounce case */
     /* choose debounce filter and configure the delay
         according to the given argument value */
else                                          /* deglitch case */
     /* choose deglitch filter */


Slow clock is running at 32KHz which gives a 30 usec clock cycle.

>
> (this kind of thing is why I'm not convinced that generic pinconf works
> so well... What if we need psecs in the future?)

Should I keep the at91 native pinconf binding and add the missing flags 
to this binding
(OUTPUT configuration flags) ?

This was another question I asked in my cover letter: wether or not the 
generic pinconf
binding should be used.

