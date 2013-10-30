Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3J3NCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:02:53 -0400
Received: from mail.lemote.com ([222.92.8.138]:33178 "EHLO mail.lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786Ab3J3NCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:02:52 -0400
Message-ID: <d805289014727dc4aa7ce29861947c6a.squirrel@mail.lemote.com>
In-Reply-To: <alpine.DEB.2.02.1310301105260.19212@ionos.tec.linutronix.de>
References: <1380334284-12690-1-git-send-email-chenhc@lemote.com>
    <alpine.DEB.2.02.1310291402490.8257@ionos.tec.linutronix.de>
    <fd7ba5f27786bbd812c19dcd6c589eb2.squirrel@mail.lemote.com>
    <alpine.DEB.2.02.1310301105260.19212@ionos.tec.linutronix.de>
Date: Wed, 30 Oct 2013 21:02:47 +0800
Subject: Re: [PATCH] genirq: Avoid NULL OOPS in irq handling
From: =?gb2312?Q?=22=B3=C2=BB=AA=B2=C5=22?= <chenhc@lemote.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=gb2312
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 30 Oct 2013, "³Â»ª²Å" wrote:
>
>> I use a Loongson-3(MIPS-series CPU) machine, there is a serial port
>> integrated in the CPU (but it iss buggy), and it use handle_percpu_irq()
>> as the irq handler. Maybe I should move the checking into
>> handle_percpu_irq()?
>
> Why is a device interrupt using handle_percpu_irq()?
Seems that IRQs directly deliverd to MIPS CPU (those without interrupt
controller) are all handled by handle_percpu_irq().... I will try to
overwrite the handler in arch-specific code and keep the code in kernel/
irq as is. Thanks.
>
> Thanks,
>
> 	tglx


