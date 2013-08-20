Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3HTQld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:41:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46353 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3HTQlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:41:32 -0400
Message-ID: <52139C38.6000006@wwwdotorg.org>
Date: Tue, 20 Aug 2013 10:41:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrzej Hajda <a.hajda@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] max77693: added device tree support
References: <20130819104409.GA21520@lee--X1> <1376912426-14747-1-git-send-email-a.hajda@samsung.com> <52128BAD.6020903@wwwdotorg.org> <52136400.7040406@samsung.com>
In-Reply-To: <52136400.7040406@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 06:41 AM, Andrzej Hajda wrote:
> Hi,
> 
> Thanks for the review.
> 
> On 08/19/2013 11:18 PM, Stephen Warren wrote:
>> On 08/19/2013 05:40 AM, Andrzej Hajda wrote:
>>> max77693 mfd main device uses only wakeup field
>>> from max77693_platform_data. This field is mapped
>>> to wakeup-source common property in device tree.
>>> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
>>>  Optional properties:
>>>  - regulators : The regulators of max77693 have to be instantiated under subnod
>>>    named "regulators" using the following format.
>>> +- wakeup-source : Indicates if the device can wakeup the system from the sleep
>>> +  state.
>>
>> Does the property mean "can" or "should"?
>>
>> "Can" implies that the property means something about the HW. What
>> exactly does it mean; perhaps that some specific output pin of the chip
>> has been wired to an input IRQ/GPIO of the SoC or PMIC that (can) wake
>> up the system? If so, which pin, signal, ...? Also, doesn't this also
>> depend on the SoC itself supporting its input IRQ/GPIO as a wakeup
>> source, so isn't some co-ordination required between the SoC and chip,
>> such that this property doesn't mean "can wakeup the system", but simply
>> "a signal is routed to the SoC, so perhaps it can wakeup the system".
>>
>> "Should" implies policy, which probably shouldn't be represented in
>> device tree, since DT should describe the HW and not how it should be used.
>
> After short digging I have realized that "wakeup-source" property is
> already parsed by 
> of_i2c_register_devices core function and it should not be parsed again
> by the driver itself.
> So I suppose the description of it can be removed from max77693 binding.
> Do you agree?

Well, that in turn means that the core I2C binding should describe this
property, and it doesn't. So, that just means you need to apply this
part of the patch to a different document instead, but doesn't remove
the need to document exactly what it means...

But, it's reasonable to go ahead and add DT support to the driver based
on the current binding in this patch, and add the documentation for this
property to the I2C core binding document in some other patch.
