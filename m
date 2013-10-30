Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3J3HTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:19:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39729 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3J3HTD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:19:03 -0400
Subject: Re: [PATCH 4/6] edac: Document Krait L1/L2 EDAC driver binding
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20131030003805.GC3268@kartoffel>
Date: Wed, 30 Oct 2013 02:19:00 -0500
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <302FC9DF-1149-4B71-AFC6-7DE05885F2CE@codeaurora.org>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org> <1383006690-6754-5-git-send-email-sboyd@codeaurora.org> <90D2FDE5-C43F-4ACF-B287-4E0AD8617892@codeaurora.org> <526FF7DB.5040805@codeaurora.org> <20131030003805.GC3268@kartoffel>
To: Mark Rutland <mark.rutland@arm.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 29, 2013, at 7:38 PM, Mark Rutland wrote:

> On Tue, Oct 29, 2013 at 06:00:59PM +0000, Stephen Boyd wrote:
>> On 10/29/13 01:21, Kumar Gala wrote:
>>> On Oct 28, 2013, at 7:31 PM, Stephen Boyd wrote:
>>> 
>>>> The Krait L1/L2 error reporting device is made up of two
>>>> interrupts, one per-CPU interrupt for the L1 caches and one
>>>> interrupt for the L2 cache.
>>>> 
>>>> Cc: <devicetree@vger.kernel.org>
>>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>>> ---
>>>> .../devicetree/bindings/arm/qcom,krait-cache-erp.txt     | 16 ++++++++++++++++
>>>> 1 file changed, 16 insertions(+)
>>>> create mode 100644 Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
>>>> 
>>>> diff --git a/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt b/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
>>>> new file mode 100644
>>>> index 0000000..01fe8a8
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
>>>> @@ -0,0 +1,16 @@
>>>> +* Qualcomm Krait L1 / L2 cache error reporting
>>>> +
>>>> +Required properties:
>>>> +- compatible: Should be "qcom,krait-cache-erp"
>>>> +- interrupts: Should contain the L1/CPU error interrupt number and
>>>> +  then the L2 cache error interrupt number
>>>> +
>>>> +Optional properties:
>>>> +- interrupt-names: Should contain the interrupt names "l1_irq" and
>>>> +  "l2_irq"
>>>> +
>>>> +Example:
>>>> +	edac {
>>>> +		compatible = "qcom,krait-cache-erp";
>>>> +		interrupts = <1 9 0xf04>, <0 2 0x4>;
>>>> +	};
>>> Why wouldn't we have these as part of cache nodes in the dts?  (which begs the question why we don't have cache nodes?)
>>> 
>> 
>> I can certainly add cache nodes and cpu nodes and then put the
>> interrupts in those nodes. I was thinking along those same lines when I
>> ported this driver but figured it would be good to get something out
>> there. The only question I have is how am I supposed to hook that up
>> into the linux device model? Will the edac driver bind to the device
>> created for the cpus node and the cache node? I guess it will have to be
>> a driver that binds to two devices.
>> 
>> One could argue that we should put the cp15 based architected timers in
>> the cpus node also but so far nobody has done that and I think there was
>> some reasoning behind that, Mark?
> 
> The architected timer binding was created at a time I wasn't involved in kernel
> development, and I'm not aware of any particular reasoning. I've heard that
> there was a decision to not duplicate banked resources, which would explain not
> having the timer under /cpus/cpu@N, but doesn't imply that having it under
> /cpus is bad.
> 
> Do we have precedent for putting any devices other than CPUs in /cpus?

On PPC we had core cache's (depending on topology) that would be there, and thus why I raised the suggestion.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

