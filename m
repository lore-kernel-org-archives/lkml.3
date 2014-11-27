Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaK0L7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:59:52 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53394 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbaK0L7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:59:48 -0500
MIME-Version: 1.0
In-Reply-To: <54761BFC.4020705@ti.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
	<1416917818-10506-6-git-send-email-chunyan.zhang@spreadtrum.com>
	<54761BFC.4020705@ti.com>
Date: Thu, 27 Nov 2014 19:59:46 +0800
Message-ID: <CAAfSe-uMqy7zwiEK+nDoMPw_oni8L_vq7oW2Me5AY8z8KGpjwQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver support
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Grant Likely <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        gnomes@lxorguk.ukuu.org.uk, Jonathan Corbet <corbet@lwn.net>,
        jason@lakedaemon.net, Mark Brown <broonie@kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        florian.vaussard@epfl.ch, andrew@lunn.ch,
        Hayato Suzuki <hytszk@gmail.com>, Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        lanqing.liu@spreadtrum.com,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2@ti.com>:
> On 11/25/2014 07:16 AM, Chunyan Zhang wrote:
>>
>> Add a full sc9836-uart driver for SC9836 SoC which is based on the

>> +#include<linux/clk.h>
>
> How about sorting this includes? asm/irq.h go first followed linux/ in
> alphabatical order?

>> +static irqreturn_t sprd_handle_irq(int irq, void *dev_id)
>> +{
>> +       struct uart_port *port = (struct uart_port *)dev_id;
>> +       u32 ims;
>> +
>> +       ims = serial_in(port, SPRD_IMSR);
>> +
>> +       serial_out(port, SPRD_ICLR, ~0);
>> +
>> +       if (ims&  (SPRD_IMSR_RX_FIFO_FULL |
>> +               SPRD_IMSR_BREAK_DETECT | SPRD_IMSR_TIMEOUT)) {
>> +               sprd_rx(irq, port);
>> +       }
>> +       if (ims&  SPRD_IMSR_TX_FIFO_EMPTY)
>> +               sprd_tx(irq, port);
>> +
>> +       return IRQ_HANDLED;
>
> You are always returning IRQ_HANDLED and this is registered as a SHARED irq.
> Is there a chance this handler is called and the irq event doesn't
> belong to this device?
>
> Murali

You are right, this is not a SHARED irq. I'll pass 0 for irqflags when
called 'devm_request_irq' in the next version patch.

Thank you,
Chunyan
