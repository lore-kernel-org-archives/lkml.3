Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbbAZQQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:16:15 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:48794 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbbAZQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:16:13 -0500
MIME-Version: 1.0
In-Reply-To: <1421156665-27318-3-git-send-email-mpa@pengutronix.de>
References: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
	<1421156665-27318-3-git-send-email-mpa@pengutronix.de>
Date: Mon, 26 Jan 2015 11:16:12 -0500
Message-ID: <CAECXXi5GcAbBzS+ATr2BRryJPvAUPCTMkmVT2TKWESG6anWuWw@mail.gmail.com>
Subject: Re: [RFC 2/4] nbd: Split 'DO_IT' into three functions
From: Paul Clements <paul.clements@us.sios.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: "nbd-general@lists.sourceforge.net" 
	<nbd-general@lists.sourceforge.net>,
        kernel list <linux-kernel@vger.kernel.org>, kernel@pengutronix.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

This refactor looks OK with the exception of one thing...

On Tue, Jan 13, 2015 at 8:44 AM, Markus Pargmann <mpa@pengutronix.de> wrote:

>  /* Must be called with tx_lock held */
>
>  static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
> @@ -684,61 +773,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
>                 set_capacity(nbd->disk, nbd->bytesize >> 9);
>                 return 0;
>
> -       case NBD_DO_IT: {
> -               struct task_struct *thread;
> -               struct socket *sock;
> -               int error;
> -
> -               if (nbd->pid)
> -                       return -EBUSY;
> -               if (!nbd->sock)
> -                       return -EINVAL;
>

You seem to have done away with these checks. Was that inadvertent or
was there a reason for that? The pid check is necessary to prevent two
instances of NBD_DO_IT from running. Without the sock check you'll get
a null pointer deref in nbd_do_it.

Thanks,
Paul
