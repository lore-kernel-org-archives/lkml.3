Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbbAQX4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 18:56:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56107 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbbAQX4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 18:56:10 -0500
Date: Sat, 17 Jan 2015 15:48:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        ldv-project@linuxtesting.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, HPDD-discuss@ml01.01.org
Subject: Re: [PATCH] staging: lustre: do not ignore try_module_get() fail in
 obd_class_open()
Message-ID: <20150117234830.GA26997@kroah.com>
References: <1419636413-17452-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419636413-17452-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 02:26:53AM +0300, Alexey Khoroshilov wrote:
> obd_class_open() ignores error code of try_module_get(),
> while it can lead to race with module unload.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/lustre/lustre/obdclass/linux/linux-module.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
> index 66ceab20c743..bb4bc72ddac7 100644
> --- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
> +++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
> @@ -168,8 +168,7 @@ EXPORT_SYMBOL(obd_ioctl_popdata);
>  /*  opening /dev/obd */
>  static int obd_class_open(struct inode *inode, struct file *file)
>  {
> -	try_module_get(THIS_MODULE);
> -	return 0;
> +	return try_module_get(THIS_MODULE);
>  }

This code is totally wrong and racy and should just be fixed up
properly.  No module can lock it's own code, we know better than this.

thanks,

greg k-h
