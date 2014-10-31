Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbaJaKPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:15:48 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35337 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbaJaKPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:15:46 -0400
MIME-Version: 1.0
In-Reply-To: <20141031100925.GA798@leverpostej>
References: <1413871011-4101-1-git-send-email-ankit.jindal@linaro.org>
 <1413871011-4101-6-git-send-email-ankit.jindal@linaro.org>
 <20141021091412.GB15293@leverpostej> <CAPTm99X9k+cfELMLL8_PmYN6RNn7CL7KugnV5JKcW6Jqhs8idg@mail.gmail.com>
 <20141031100925.GA798@leverpostej>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Fri, 31 Oct 2014 15:45:25 +0530
Message-ID: <CAPTm99V1m4QQReQTBJfN5biBtvg1KTSpW_vF67mPnCt30szSuA@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] Documentation: dt-bindings: Add binding info for
 X-Gene QMTM UIO driver
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "patches@apm.com" <patches@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Varka Bhadram <varkabhadram@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 October 2014 15:39, Mark Rutland <mark.rutland@arm.com> wrote:
>> >> +Required properties:
>> >> +- compatible: Should be "apm,xgene-qmtm"
>> >> +- reg: Address and length of the register set for the device. It contains the
>> >> +  information of registers in the same order as described by reg-names.
>> >> +- reg-names: Should contain the register set names
>> >> +  - "csr": QMTM control and status register address space.
>> >> +  - "fabric": QMTM memory mapped access to queue states.
>> >> +- qpool: Points to the phandle of the node defining memory location for
>> >> +      creating QMTM queues. This could point either to the reserved-memory
>> >> +      node (as-per reserved memory bindings) or to the node of on-chip
>> >> +      SRAM etc. It is expected that size and location of qpool memory will
>> >> +      be configurable via bootloader.
>> >
>> > Is that on-chip SRAM part of the QMTM, or is that a shared part of the
>> > SoC?
>> Its not part of QMTM.
>>
>> >
>> > It feels odd to have a phandle that can go to completely different
>> > classes of node, especially as you will need to use a different API to
>> > acquire the memory region within Linux.
>> It is expected that phandle will point to a node whose first reg
>> property will be only for qpool memory.
>
> Even if that's true you will need to use completely different APIs for
> accessing that memory (so that the kernel can account the use of
> reserved-memory correctly), so this might not be the best design. It
> might be better to have qpool-sram and qpool-memory properties that
> point at an sram node or a reserved-memory node respectively.
Thanks, I will go as per your suggestion. I will add two properties
qpool-sram and qpool-memory to tackle this.
>
>> >
>> >> +- clocks: Reference to the clock entry.
>> >
>> > Just the one clock? Does the clock input to the QMTM have a name?
>> Just one input clock. There is no specific name of it.
>
> Ok.
>
>>
>> >
>> >> +- num-queues: Number of queues under this QMTM device.
>> >> +- devid: QMTM identification number for the system having multiple QMTM devices.
>> >> +      This is used to form a unique id (a tuple of queue number and
>> >> +      device id) for the queues belonging to this device.
>> >
>> > Is this just an arbitrary unique ID, or is this a non-probeable property
>> > of the HW? If the former, isn't the base address sufficient as a unique
>> > identifier?
>> Its a non-probeable property of the HW.
>
> Ok. That sounds fine then.
>

Thanks,
Ankit
> Thanks,
> Mark.
