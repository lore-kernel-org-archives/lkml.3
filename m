Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbbAZLZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:25:19 -0500
Received: from mail.linn.co.uk ([195.59.102.251]:50223 "EHLO mail.linn.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbbAZLZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:25:17 -0500
Message-ID: <54C623BE.6010206@linn.co.uk>
Date: Mon, 26 Jan 2015 11:23:42 +0000
From: Stathis Voukelatos <stathis.voukelatos@linn.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "abrestic@chromium.org" <abrestic@chromium.org>
Subject: Re: [PATCH] net: Linn Ethernet Packet Sniffer driver
References: <1422007621-13567-1-git-send-email-stathis.voukelatos@linn.co.uk> <3515756.ch1oRd7PaS@wuerfel>
In-Reply-To: <3515756.ch1oRd7PaS@wuerfel>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.2.10.219]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23/01/15 10:21, Arnd Bergmann wrote:
> On Friday 23 January 2015 10:07:01 Stathis Voukelatos wrote:
>> +- interrupts : sniffer interrupt specifier
>> +- clocks : specify the system clock for the peripheral
>> +- clock-names : must contain the "sys" entry
>> +- fifo-block-words : number of words in one data FIFO entry
>> +
>> +Example:
>> +
>> +sniffer@1814a000 {
>> +        compatible = "linn,eth-sniffer";
>> +        reg = <0x1814a000 0x100>, <0x1814a400 0x400>, <0x1814a800 0x400>;
>> +        reg-names = "regs", "tx-ram", "rx-ram";
>> +        interrupts = <GIC_SHARED 58 IRQ_TYPE_LEVEL_HIGH>;
>> +        interrupt-names = "eth-sniffer-irq";
>> +        clocks = <&system_clk>;
>> +        clock-names = "sys";
>> +        fifo-block-words = <4>;
>>
> The example contains an interrupt-names property that is not documented.
> If you want to name interrupts, the exact name strings need to
> be mandated by the binding. Alternatively just drop the name.
> I notice that the driver requests the first interrupt without giving
> a name anyway, and the description above suggests that there can
> only be one interrupt.
>
> 	Arnd
>
Hi Arnd,
Yes, we can probably just drop the interrupt name field.
It will be done in the next version of the patch set.
Thank you,
Stathis

