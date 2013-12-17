Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3LQRjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:39:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3LQRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:39:34 -0500
Date: Tue, 17 Dec 2013 09:39:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: xqx12 <s2exqx@gmail.com>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, chyyuu@gmail.com,
        xuyongjiande@gmail.com, xqx12 <xiaoqixue_1@163.com>
Subject: Re: [PATCH] tty: an overflow of multiplication in
 drivers/tty/cyclades.c
Message-ID: <20131217173934.GA9074@kroah.com>
References: <1387203696-10759-1-git-send-email-xiaoqixue_1@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387203696-10759-1-git-send-email-xiaoqixue_1@163.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 10:21:36PM +0800, xqx12 wrote:
> there is an overflow in the code :
> cyz_polling_cycle = (arg * HZ) / 1000,
> the multiplicator arg comes from user, so it may be an overflow if
> arg is a big number. And the value of cyc_polling_cycle will be
> wrong when it is used next time.
> 
> Reported-by: Qixue Xiao <xiaoqixue_1@163.com>
> Suggested-by: Yongjian Xu <xuyongjiande@gmail.com>
> Suggested-by: Yu Chen <chyyuu@gmail.com>
> Signed-off-by: Qixue Xiao <xiaoqixue_1@163.com>
> ---
>  drivers/tty/cyclades.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
> index cfeec97..7eec1c5 100644
> --- a/drivers/tty/cyclades.c
> +++ b/drivers/tty/cyclades.c
> @@ -2728,7 +2728,8 @@ cy_ioctl(struct tty_struct *tty,
>  		break;
>  #ifndef CONFIG_CYZ_INTR
>  	case CYZSETPOLLCYCLE:
> +		if (arg > LONG_MAX / HZ)
> +			return -ENODEV;

This patch fails to apply at all to any of my trees, can you please redo
it against the latest tty tree and resend it so that I can apply it?

thanks,

greg k-h
