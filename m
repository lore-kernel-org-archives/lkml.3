Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaGBGPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:15:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42363 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaGBGPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:15:21 -0400
MIME-Version: 1.0
In-Reply-To: <1402866165-17408-1-git-send-email-minipli@googlemail.com>
References: <1402866165-17408-1-git-send-email-minipli@googlemail.com>
Date: Wed, 2 Jul 2014 08:15:20 +0200
Message-ID: <CA+rthh-CYWjUCji4GXNeZV5CcLd3_DNaV9zFDc_DznYbyw6T+A@mail.gmail.com>
Subject: Re: [PATCH] agp: remove read/write stubs
From: Mathias Krause <minipli@googlemail.com>
To: David Airlie <airlied@linux.ie>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 June 2014 23:02, Mathias Krause <minipli@googlemail.com> wrote:
> The VFS layer handles those in the very same way, if unset. No need for
> additional stubs.
>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/char/agp/frontend.c |   15 ---------------
>  1 file changed, 15 deletions(-)
>
> diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
> index b29703324e..09f17eb734 100644
> --- a/drivers/char/agp/frontend.c
> +++ b/drivers/char/agp/frontend.c
> @@ -710,19 +710,6 @@ static int agp_open(struct inode *inode, struct file *file)
>         return 0;
>  }
>
> -
> -static ssize_t agp_read(struct file *file, char __user *buf,
> -                       size_t count, loff_t * ppos)
> -{
> -       return -EINVAL;
> -}
> -
> -static ssize_t agp_write(struct file *file, const char __user *buf,
> -                        size_t count, loff_t * ppos)
> -{
> -       return -EINVAL;
> -}
> -
>  static int agpioc_info_wrap(struct agp_file_private *priv, void __user *arg)
>  {
>         struct agp_info userinfo;
> @@ -1047,8 +1034,6 @@ static const struct file_operations agp_fops =
>  {
>         .owner          = THIS_MODULE,
>         .llseek         = no_llseek,
> -       .read           = agp_read,
> -       .write          = agp_write,
>         .unlocked_ioctl = agp_ioctl,
>  #ifdef CONFIG_COMPAT
>         .compat_ioctl   = compat_agp_ioctl,
> --
> 1.7.10.4
>

Ping. Any objections, comments? David?
