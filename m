Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaEFLwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:52:40 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:46647 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaEFLwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:52:36 -0400
MIME-Version: 1.0
In-Reply-To: <1399173287.6962.3.camel@phoenix>
References: <1399173287.6962.3.camel@phoenix>
Date: Tue, 6 May 2014 15:52:35 +0400
Message-ID: <CABjd4Yw=U4S0H4bqhrnuHbt3hYVke7GbOeGgPpVJfGhLJ=iWyQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] irqchip: vt8500: Properly mask the interrupt in irq_mask()
From: Alexey Charkov <alchark@gmail.com>
To: "VT8500/WM8505 Linux Kernel" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Tony Prisk <linux@prisktech.co.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-04 7:14 GMT+04:00 Axel Lin <axel.lin@ingics.com>:
> Current code sets both irq_ack and irq_mask callbacks to vt8500_irq_mask().
> However, vt8500_irq_mask does not clear interrupt enable bit when the interrupt
> trigger mode is edge trigger.
>
> This patch moves the code clearing Interrupt Status Register bit to irq_ack().
> Make irq_mask() always clear interrupt enable bit for all interrupt trigger mode.
>
> According to the datasheet, the Interrupt Status Register is written one to
> clear(Write 0 has no effect). So we don't need a read-modify-write operation
> for clearing a bit in interrupt status register.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Resend and also CC: vt8500-wm8505-linux-kernel@googlegroups.com.
> I appreciate if someone can test this patch.

Axel, I believe the change makes perfect sense. Current code seems to
be based on my original code that was in turn based on very limited
understanding of the hardware, and furthermore I don't think that any
of the existing drivers use edge-triggered interrupts anyway.

The way you've structured it seems more logical, so I would be happy
for this to be merged.

Just booted a kernel with this patch on my WM8850, and everything
seems to work fine. Can't really say 'Tested-by', though, given the
above (no existing uses of edge-triggered interrupts that I'm aware
of).

Thanks a lot,
Alexey
