Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab3CRT6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:58:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48453 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CRT6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:58:53 -0400
Date: Mon, 18 Mar 2013 22:58:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/8] staging: omap-thermal: use spin_lock_irqsave inside
 IRQ handler
Message-ID: <20130318195837.GS9189@mwanda>
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
 <1363618756-15851-3-git-send-email-eduardo.valentin@ti.com>
 <20130318191618.GU9138@mwanda>
 <51476D3E.6010305@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51476D3E.6010305@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 03:38:38PM -0400, Eduardo Valentin wrote:
> On 18-03-2013 15:16, Dan Carpenter wrote:
> >On Mon, Mar 18, 2013 at 10:59:10AM -0400, Eduardo Valentin wrote:
> >>Even if the IRQ is not firing because it is ONE_SHOT and disable
> >>at INTC level, the IRQ handler must use spin_lock_irqsave.
> >>It is necessary to disable IRQs from the current
> >>CPU while it is holding a spin_lock which is need.
> >>
> >
> >Gar...  I think I was just totally wrong on this.  I think your
> >original code was fine.  Sorry Eduardo and Greg.
> >
> >This is a threaded IRQ so the regular spin_lock is fine or even the
> >mutex would have been.
> 
> In fact it is. But I rather prefer to use spinlocks there, just to
> keep the irq handler sane, even if it is moved to non-threaded IRQ.

Yep.  I'd agree there.

> 
> >
> >IRQ_ONESHOT is about triggering a second IRQ before the first one
> >has been finished, btw.
> 
> It is, and that gets done by masking the IRQ at INTC level.
> 
> >
> >I am an idiot.
> 
> 
> Not really. Thanks for your time reviewing the driver.
> 
>  I will resend this series. Drop this one and split patch 4/8 into
> two I think (one for moving files, one for renaming functions)

Great.  Much appreciated.

regards,
dan carpenter

