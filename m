Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbaGBREW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 13:04:22 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:48678 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaGBREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 13:04:20 -0400
Date: Wed, 2 Jul 2014 21:04:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Linux ARM kernel mailing list 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [patch 3/4] timerfd: Implement timerfd_ioctl method to restore
 timerfd_ctx::ticks
Message-ID: <20140702170416.GG12440@moon>
References: <20140623185431.396309193@openvz.org>
 <20140623190345.499956567@openvz.org>
 <20140624220351.GZ2095@moon>
 <53B4382F.9030908@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B4382F.9030908@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 12:49:51PM -0400, Christopher Covington wrote:
> >  
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +static long timerfd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> > +{
> > +	struct timerfd_ctx *ctx = file->private_data;
> > +	int ret = 0;
> > +
> > +	switch (cmd) {
> > +	case TFD_IOC_SET_TICKS: {
> > +		u64 ticks;
> > +
> > +		if (get_user(ticks, (u64 __user *)arg))
> 
> 64-bit get_user is currently unsupported on ARM, although it appears work is
> ongoing [1].
> 
> 1. https://lkml.org/lkml/2014/6/17/260

Thanks for info, Christopher! What arm camp is using then, copy-from-user?
