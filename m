Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab3FTJyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:54:09 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30187 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3FTJyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:54:07 -0400
X-Spam-Score: -100.8
Message-ID: <51C2D10B.5030408@asianux.com>
Date: Thu, 20 Jun 2013 17:53:15 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of spin_lock
 + local_irq_save, especially when CONFIG_LOCKDEP not defined
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C1861A.6030901@asianux.com> <alpine.DEB.2.02.1306191249260.4013@ionos.tec.linutronix.de> <51C2BF3C.8020804@asianux.com> <alpine.DEB.2.02.1306201102330.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306201102330.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 05:07 PM, Thomas Gleixner wrote:
> On Thu, 20 Jun 2013, Chen Gang wrote:
>> > On 06/19/2013 06:53 PM, Thomas Gleixner wrote:
>>> > > So
>>> > > 	local_irq_save(flags);
>>> > > 	spin_lock(&lock);
>>> > > 
>>> > > is semantically the same as 
>>> > > 
>>> > > 	spin_lock_irqsave(&lock, flags);
>>> > > 
>> > 
>> > Yes (but reverse is NO).
>> > 
>>> > > And this is completely independent of LOCKDEP.
>> > 
>> > NO.
>> > 
>> >  	spin_lock_irqsave(&lock, flags);
>> > 
>> >  is not semantically the same as
>> > 
>> >  	local_irq_save(flags);
>> >  	spin_lock(&lock);
> If A is semantically the same as B, then B is semantically the same as
> A. At least that's the common understanding.
> 

  From A to B is OK.

Not means:

  From B to A is also OK.


> You seem to have a different definition of semantics, but I prefer the
> common one.
>  
>> > It depend on the spin_lock_irqsave() implementation, if the parameters
>> > has no relation ship with each other, semantically the same.
> Yes, it depends on the implementation, but all implementations do:
> 
>      local_irq_save(flags);
>      arch_spin_lock_flags(l, flags);
> 

Yes this is spin_lock_irqsave().

At least, this implemenation is not equal to.

	local_irq_save(flags);
	spin_lock(l);

So if for arch_spin_lock_flags(), 'flags' is no relation ship with 'l',
we can say semantically the same.



Thanks.
-- 
Chen Gang

Asianux Corporation
