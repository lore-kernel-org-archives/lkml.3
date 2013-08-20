Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313Ab3HTMlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:41:49 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30941 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab3HTMlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:41:47 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-16-521364093e34
Message-id: <52136400.7040406@samsung.com>
Date: Tue, 20 Aug 2013 14:41:36 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Lee Jones <lee.jones@linaro.org>, Rob Herring <rob.herring@calxeda.com>,
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
References: <20130819104409.GA21520@lee--X1>
 <1376912426-14747-1-git-send-email-a.hajda@samsung.com>
 <52128BAD.6020903@wwwdotorg.org>
In-reply-to: <52128BAD.6020903@wwwdotorg.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xK7qcKcJBBmevCFvMP3KO1eLAnx2M
	Fm96O1gsOs8+YbY42/SG3eL+16OMFpd3zWGzWHr9IpPFhOlrWSwOrzjAZLHu5XQg6007q8Xp
	blaLVwfbWBz4PNbMW8PoseDzFXaP15MnMHq8Wj2T1ePOtT1sHvNOBnr0bVnF6PF5k5zHxrmh
	AZxRXDYpqTmZZalF+nYJXBm7Vv1hLfgtVHFjynumBsZ1/F2MnBwSAiYS/Tfa2CFsMYkL99az
	dTFycQgJLGWU+PrnKCNIQkjgE6PEwXdeIDavgJbE7rudYHEWAVWJtTtbWUBsNgFNib+bb7KB
	2KICERIrlzxghagXlPgx+R5YjQhQ76Rn/xhBFjALzGeR+N+0EWyQsIC1xKUzE1kgNncySlz7
	/hbI4eDgFNCVmHfLBaSGWUBHYn/rNDYIW15i85q3zBMYBWYh2TELSdksJGULGJlXMYqmliYX
	FCel5xrpFSfmFpfmpesl5+duYoTE09cdjEuPWR1iFOBgVOLh7VASChJiTSwrrsw9xCjBwawk
	wvvaUThIiDclsbIqtSg/vqg0J7X4ECMTB6dUA2ONh+QpF04/Z1nJtUr8hyrWFD7nEejOas1t
	DYub3fjG59oOpbMBLgu/5LexitQec737WM7V8PykNR2V/NujTDoqskVM6/s6Kr7/iQzTmP0w
	yfdmoLBy8fYzXkfvLPy9cGub9bfMkmlFBpsKfA/ovd7JH+WeIrjWUoVnT/+N95P+GSzn41rn
	o8RSnJFoqMVcVJwIAJun+TuFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for the review.

On 08/19/2013 11:18 PM, Stephen Warren wrote:
> On 08/19/2013 05:40 AM, Andrzej Hajda wrote:
>> max77693 mfd main device uses only wakeup field
>> from max77693_platform_data. This field is mapped
>> to wakeup-source common property in device tree.
>> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
>>  Optional properties:
>>  - regulators : The regulators of max77693 have to be instantiated under subnod
>>    named "regulators" using the following format.
>> +- wakeup-source : Indicates if the device can wakeup the system from the sleep
>> +  state.
> Does the property mean "can" or "should"?
>
> "Can" implies that the property means something about the HW. What
> exactly does it mean; perhaps that some specific output pin of the chip
> has been wired to an input IRQ/GPIO of the SoC or PMIC that (can) wake
> up the system? If so, which pin, signal, ...? Also, doesn't this also
> depend on the SoC itself supporting its input IRQ/GPIO as a wakeup
> source, so isn't some co-ordination required between the SoC and chip,
> such that this property doesn't mean "can wakeup the system", but simply
> "a signal is routed to the SoC, so perhaps it can wakeup the system".
>
> "Should" implies policy, which probably shouldn't be represented in
> device tree, since DT should describe the HW and not how it should be used.
After short digging I have realized that "wakeup-source" property is
already parsed by 
of_i2c_register_devices core function and it should not be parsed again
by the driver itself.
So I suppose the description of it can be removed from max77693 binding.
Do you agree?

Anyway I will prepare separate patch removing wakeup related code from
probe and
related field from max77693 platform_data - i2c_board_info::flag field
should be used instead.
>
> Finally, if there was already a binding for max77693.txt, I don't think
> the patch subject "added device tree support" is entirely accurate; this
> change to the binding document seems to be more about adding a new
> feature than adding DT support to the driver...
>
This patch really adds DT support to max77693 mfd driver :)

The binding file which is already in kernel currently has no related
code in the max77693 driver.
I will add clarification in the commit message.

Regards
Andrzej


