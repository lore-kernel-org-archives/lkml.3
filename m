Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab3HTSDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:03:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55315 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3HTSDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:03:34 -0400
Subject: Re: [PATCH 2/4] devicetree: serial: Document msm_serial bindings
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=US-ASCII
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <5213A0A7.9010502@codeaurora.org>
Date: Tue, 20 Aug 2013 13:03:31 -0500
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        David Brown <davidb@codeaurora.org>, devicetree@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <CB6CE708-148D-4C36-AB4C-373DAB91B80E@codeaurora.org>
References: <1376948397-6882-1-git-send-email-sboyd@codeaurora.org> <1376948397-6882-3-git-send-email-sboyd@codeaurora.org> <543F6671-8317-446A-B14A-147373BCA9B6@codeaurora.org> <5213A0A7.9010502@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 20, 2013, at 12:00 PM, Stephen Boyd wrote:

> On 08/20/13 07:41, Kumar Gala wrote:
>> On Aug 19, 2013, at 4:39 PM, Stephen Boyd wrote:
>> 
>>> diff --git a/Documentation/devicetree/bindings/serial/msm_serial.txt b/Documentation/devicetree/bindings/serial/msm_serial.txt
>>> new file mode 100644
>>> index 0000000..a6efac3
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/serial/msm_serial.txt
>>> @@ -0,0 +1,82 @@
>>> +* MSM Serial UART and UARTDM
>>> +
>>> +There are two MSM serial hardware designs. UARTDM is designed for use with a
>>> +dma engine in high-speed use cases and the non-DM design is for lower speed use
>>> +cases. The two designs are mostly compatible from a software perspective except
>>> +the non-DM design can only read and write one character at a time and so the
>>> +register layout differs slightly.
>> I think you split this into two binding spec docs, one for each type of uart.
> 
> Should split into two files? I can do that.

yes.


>>> +UART
>>> +----
>>> +Required properties:
>>> +- compatible: Should contain "qcom,msm-uart"
>>> +- reg: Should contain UART register location and length. The first
>> first? is there more than one reg region?

?

>>> +       register shall specify the main control registers
>>> +- interrupts: Should contain UART interrupt.
>>> +- clocks: Should contain the core clock.
>>> +- clock-names: Should be "core_clk".
>>> +
>>> +Optional properties:
>>> +- dmas: Should contain dma specifiers for transmit and receive
>>> +- dma-names: Should contain "tx" for transmit and "rx" for receive
>> confused, above you say the non-DM doesn't support DMA so, why the optional props?
> 
> Ah sorry, copy pasta.
> 
>> 
>>> +
>>> +Example:
>>> +
>>> +A uart device with dma capabilities.
>>> +
>>> +serial@a9c00000 {
>>> +	compatible = "qcom,msm-uart";
>>> +	reg = <0xa9c00000 0x1000>;
>>> +	interrupts = <11>;
>>> +	clocks = <&uart_cxc>;
>>> +	clock-names = "core_clk";
>>> +	dmas = <&dma0 0>, <&dma0 1>;
>>> +	dma-names = "tx", "rx";
>>> +};
>>> +
>>> +UARTDM
>>> +------
>>> +Required properties:
>>> +- compatible: Should contain at least "qcom,msm-uartdm".
>>> +              A more specific property should be specified as follows depending
>>> +	      on the version:
>>> +		"qcom,msm-uartdm-v1.1"
>>> +		"qcom,msm-uartdm-v1.2"
>>> +		"qcom,msm-uartdm-v1.3"
>>> +		"qcom,msm-uartdm-v1.4"
>>> +- reg: Should contain UART register locations and lengths. The first
>>> +       register shall specify the main control registers. An optional second
>>> +       register location shall specify the GSBI control region.
>> Is GSBI region existing tied to particular versions (if so can we say that)
> 
> Not really. GSBI will always be related to v1.3 but not all v1.3
> hardware is part of a GSBI.

How about adding that into the binding.

>> reg-names?
> 
> Optional should be fine? The driver is already handling this without
> reg-names.
> 
>>> +- interrupts: Should contain UART interrupt.
>>> +- clocks: Should contain the core clock and the ahb clock.
>> nit, ahb in caps?
> 
> Done.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

