Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaD1Des (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 23:34:48 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:45373 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaD1Der (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 23:34:47 -0400
MIME-Version: 1.0
X-Originating-IP: [111.240.65.69]
In-Reply-To: <alpine.DEB.2.02.1404272031210.6261@ionos.tec.linutronix.de>
References: <1398611627.24297.1.camel@phoenix>
	<alpine.DEB.2.02.1404272031210.6261@ionos.tec.linutronix.de>
Date: Mon, 28 Apr 2014 11:34:46 +0800
Message-ID: <CAFRkauCmiDr+NugoVtvBaNNAaHfxVuwN_8qx7DhJK_q8A0KK8A@mail.gmail.com>
Subject: Re: [PATCH] irqchip: vt8500: Switch to a simple write clear for
 Interrupt Status Register
From: Axel Lin <axel.lin@ingics.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Prisk <linux@prisktech.co.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-28 2:34 GMT+08:00 Thomas Gleixner <tglx@linutronix.de>:
> On Sun, 27 Apr 2014, Axel Lin wrote:
>
>> According to the datasheet, the attribute of Interrupt Status Register is RW0S,
>> which means:
>>       Software can read the register.
>>       Software can also "write 1 to clear". "write 0" has no effect.
>> Thus switch the read/modify/write to a simple write clear.
>>
>> A read/modify/write does not make sense for an irq status register like this,
>> since otherwise a read/modify/write can race with a device raising an interrupt
>> and then clear the pending bit unintentionally.
>
> That's right, but what you are not seeing is that this is the mask
> callback which is supposed to mask the interrupt at the interrupt
> controller level.
>
> I have a hard time to see (even without reading the data sheet) how
> clearing a potentially pending interrupt in the status register will
> mask the interrupt line.

ok, I'll send a v2 to update the commit log.
Thanks for the review.

Regards,
Axel
