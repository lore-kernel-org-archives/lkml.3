Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3JLRuC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:50:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54147 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3JLRtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:49:43 -0400
Date: Sat, 12 Oct 2013 10:50:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/base/core.c: always output device renaming
 messages.
Message-ID: <20131012175034.GA3858@kroah.com>
References: <1381460298-1097-1-git-send-email-ethan.kernel@gmail.com>
 <20131011153544.GA14715@kroah.com>
 <CABawtvP+BqpwGYJpvBVbEUyqptSWoF0YEGqbT6o+aTP2326+7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABawtvP+BqpwGYJpvBVbEUyqptSWoF0YEGqbT6o+aTP2326+7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 02:52:51PM +0800, Ethan Zhao wrote:
> >> --- a/drivers/base/core.c
> >> +++ b/drivers/base/core.c
> >> @@ -1904,8 +1904,7 @@ int device_rename(struct device *dev, const char *new_name)
> >>       if (!dev)
> >>               return -EINVAL;
> >>
> >> -     pr_debug("device: '%s': %s: renaming to '%s'\n", dev_name(dev),
> >> -              __func__, new_name);
> >> +     dev_info(dev, "'%s' renaming to '%s'\n", dev_name(dev), new_name);
> >
> > How about:
> >         dev_dbg(dev, "renaming to '%s'\n", new_name);
> 
> If something confusing or wrong, need to take a look.
> For pr_debug(), We have to build and load a debug kernel…
> For dev_dbg(),  We have to rebuild a kernel with CONFIG_DYNAMIC_DEBUG
> set to 'y', that is default 'n'.

Why would you not enable that option these days?  All distros enable it,
and if you should too :)

> So, do you mean
> 
> dev_printk(KERN_DEBUG, dev, "renaming to '%s'\n", new_name);  ?

No, dev_dbg();.

thanks,

greg k-h
