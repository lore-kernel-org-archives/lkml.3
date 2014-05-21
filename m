Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaEUV6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 17:58:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:45250 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaEUV6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 17:58:13 -0400
Date: Thu, 22 May 2014 06:58:19 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@openvz.org>
cc: LKML <linux-kernel@vger.kernel.org>, shawn@churchofgit.com,
        Andrew Morton <akpm@linux-foundation.org>, avagin@openvz.org,
        xemul@parallels.com, vdavydov@parallels.com,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] timerfd: Implement write method
In-Reply-To: <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1405220656130.9695@ionos.tec.linutronix.de>
References: <20140428212517.200264067@openvz.org> <20140428213301.507657833@openvz.org> <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Thomas Gleixner wrote:

> On Tue, 29 Apr 2014, Cyrill Gorcunov wrote:
> > +
> > +static ssize_t timerfd_write(struct file *file, const char __user *buf,
> > +			     size_t count, loff_t *ppos)
> > +{
> > +	struct timerfd_ctx *ctx = file->private_data;
> > +	u64 ticks = 0;
> > +
> > +	if (count < sizeof(ticks))
> > +		return -EINVAL;
> > +
> > +	if (get_user(ticks, (u64 __user *) buf))
> > +		return -EFAULT;
> > +
> > +	spin_lock_irq(&ctx->wqh.lock);
> > +	ctx->ticks = ticks;
> 
> So what wakes a potential waiter in read/poll?

And who is updating timerfd_create(2) ?

Thanks,

	tglx
