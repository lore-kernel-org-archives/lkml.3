Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab3FTJNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:13:02 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52945 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab3FTJM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:12:59 -0400
Message-ID: <1371719574.3252.397.camel@edumazet-glaptop>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of
 spin_lock + local_irq_save, especially when CONFIG_LOCKDEP not defined
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Jun 2013 02:12:54 -0700
In-Reply-To: <51C2BF3C.8020804@asianux.com>
References: <51C11E83.8030902@asianux.com>
	 <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de>
	 <51C17D01.2060208@asianux.com>
	 <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de>
	 <51C1861A.6030901@asianux.com>
	 <alpine.DEB.2.02.1306191249260.4013@ionos.tec.linutronix.de>
	 <51C2BF3C.8020804@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 16:37 +0800, Chen Gang wrote:

>  	spin_lock_irqsave(&lock, flags);
> 
>  is not semantically the same as
> 
>  	local_irq_save(flags);
>  	spin_lock(&lock);
> 
> It depend on the spin_lock_irqsave() implementation, if the parameters
> has no relation ship with each other, semantically the same.

Of course all implementations must respect the blocks are
totally the same.

Arguing about this is plain silly.

If you found a buggy implementation, please fix it.


