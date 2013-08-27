Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3H0IaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:30:06 -0400
Received: from 19.mo3.mail-out.ovh.net ([178.32.98.231]:47545 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753255Ab3H0IaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:30:00 -0400
Message-ID: <521C6320.4070303@overkiz.com>
Date: Tue, 27 Aug 2013 10:28:16 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <jkosina@suse.cz>, Masanari Iida <standby24x7@gmail.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [RFC PATCH 1/3] pinctrl: add new generic pinconf config for deglitch
 filter
References: <1377379926-11163-1-git-send-email-b.brezillon@overkiz.com> <1377380109-11247-1-git-send-email-b.brezillon@overkiz.com> <521B875E.1010605@wwwdotorg.org> <521B89D1.6010902@overkiz.com> <521C2347.4080702@wwwdotorg.org> <521C4451.1060908@overkiz.com> <521C587E.6050706@atmel.com>
In-Reply-To: <521C587E.6050706@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 7156219810038052972
X-Ovh-Remote: 80.245.18.66 ()
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

On 27/08/2013 09:42, Nicolas Ferre wrote:
> On 27/08/2013 08:16, boris brezillon :
>> On 27/08/2013 05:55, Stephen Warren wrote:
>>> On 08/26/2013 11:01 AM, boris brezillon wrote:
>>>> Hello Stephen,
>>>>
>>>> On 26/08/2013 18:50, Stephen Warren wrote:
>>>>> On 08/24/2013 03:35 PM, Boris BREZILLON wrote:
>>>>>> Add a new parameter to support deglitch filter configuration.
>>>>>> A deglitch filter works like a debounce filter but with a smaller
>>>>>> delay (nanoseconds).
>>>>> Why not use the existing debounce property, just with a small delay
>>>>> specified. It seems like that's exactly what the property is for?
>>>> That's one of the question I asked in my cover letter :-)
>>>>
>>>> Indeed the at91 deglitch filter delay is not configurable and is 
>>>> statically
>>>> assigned to half a master clk cycle (if master clk = 133MHz -> 8 ns).
>>>> The debounce property argument is currently expressed in usecs.
>>>>
>>>> This will result in always selecting the debounce filter (which is 
>>>> also
>>>> available on at91 SoCs) over the deglitch filter.
>>>>
>>>> Could we add a flag in the deglitch argument to specify the delay unit
>>>> (nsecs or usecs) ?
>>> If the value is hard-coded in HW, why not use non-zero (or 1) to enable
>>> and zero to disable?
>>
>> Indeed at91 pins support both deglitch and debounce filter and I have to
>> choose
>> between the two given the argument value (in usec).
>>
>> Here's what I can do:
>>
>> if (arg >= 1/2 * slowclock)    /* debounce case */
>>       /* choose debounce filter and configure the delay
>>           according to the given argument value */
>> else                                          /* deglitch case */
>>       /* choose deglitch filter */
>>
>>
>> Slow clock is running at 32KHz which gives a 30 usec clock cycle.
>
> I am not in favor for this kind of complicated heuristic. Deglitch and 
> Debounce filters are different features in at91 (even if they pursuit 
> the same goal). So I do prefer to let the user choose which feature is 
> preferred for his application and add a different flag.
>
>
>>> (this kind of thing is why I'm not convinced that generic pinconf works
>>> so well... What if we need psecs in the future?)
>>
>> Should I keep the at91 native pinconf binding and add the missing flags
>> to this binding
>> (OUTPUT configuration flags) ?
>>
>> This was another question I asked in my cover letter: wether or not the
>> generic pinconf
>> binding should be used.
>
> The question is: how much this "generic" pinconf is... well... 
> generic! And it is not a answer I can give.
> On the other hand, if the "generic" is not going to overcome the 
> native pinctrl, I do not feel like switching to this at the cost of 
> changing the whole dtsi/dts entries that we already have.
>
> So, it is more to Linus and Stephen to give us clues about this...

Okay.

I'll propose a new patch series adding native support for OUTPUT 
configuration of at91 pins (add OUTPUT_HIGH/LOW),
and put this series in stand-by until a clear decision is made about 
generic pinconf.

Thanks,

Best Regards,

Boris
>
> Bye,
