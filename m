Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3J2UW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:22:59 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:53432 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab3J2UW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:22:56 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <526FF7DB.5040805@codeaurora.org>
References: <1383006690-6754-1-git-send-email-sboyd@codeaurora.org>
	<1383006690-6754-5-git-send-email-sboyd@codeaurora.org>
	<90D2FDE5-C43F-4ACF-B287-4E0AD8617892@codeaurora.org>
	<526FF7DB.5040805@codeaurora.org>
Date: Tue, 29 Oct 2013 13:22:55 -0700
Message-ID: <CAOesGMgG2gq9GDvEm3Dj0EZz_K=2VxgR1HhqQA5OEemKubJxVA@mail.gmail.com>
Subject: Re: [PATCH 4/6] edac: Document Krait L1/L2 EDAC driver binding
From: Olof Johansson <olof@lixom.net>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Kumar Gala <galak@codeaurora.org>, linux-edac@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:00 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 10/29/13 01:21, Kumar Gala wrote:
>> On Oct 28, 2013, at 7:31 PM, Stephen Boyd wrote:
>>
>>> The Krait L1/L2 error reporting device is made up of two
>>> interrupts, one per-CPU interrupt for the L1 caches and one
>>> interrupt for the L2 cache.
>>>
>>> Cc: <devicetree@vger.kernel.org>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>> .../devicetree/bindings/arm/qcom,krait-cache-erp.txt     | 16 ++++++++++++++++
>>> 1 file changed, 16 insertions(+)
>>> create mode 100644 Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt b/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
>>> new file mode 100644
>>> index 0000000..01fe8a8
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/arm/qcom,krait-cache-erp.txt
>>> @@ -0,0 +1,16 @@
>>> +* Qualcomm Krait L1 / L2 cache error reporting
>>> +
>>> +Required properties:
>>> +- compatible: Should be "qcom,krait-cache-erp"
>>> +- interrupts: Should contain the L1/CPU error interrupt number and
>>> +  then the L2 cache error interrupt number
>>> +
>>> +Optional properties:
>>> +- interrupt-names: Should contain the interrupt names "l1_irq" and
>>> +  "l2_irq"
>>> +
>>> +Example:
>>> +    edac {
>>> +            compatible = "qcom,krait-cache-erp";
>>> +            interrupts = <1 9 0xf04>, <0 2 0x4>;
>>> +    };
>> Why wouldn't we have these as part of cache nodes in the dts?  (which begs the question why we don't have cache nodes?)

In particular, naming the node edac seems like a suboptimal choice,
since that's a very linux-specific name for the error reporting
framework.

> I can certainly add cache nodes and cpu nodes and then put the
> interrupts in those nodes. I was thinking along those same lines when I
> ported this driver but figured it would be good to get something out
> there. The only question I have is how am I supposed to hook that up
> into the linux device model? Will the edac driver bind to the device
> created for the cpus node and the cache node? I guess it will have to be
> a driver that binds to two devices.

Or it could bind to one device and look up the info for the other from
the devicetree without relying on the driver core to instantiate
devices.


-Olof
