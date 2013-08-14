Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278Ab3HNVMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:12:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab3HNVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:12:01 -0400
Date: Wed, 14 Aug 2013 14:12:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Won Kang <wkang77@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        sachin.kamat@linaro.org, yongjun_wei@trendmicro.com.cn,
        wonkang@gctsemi.com, joe@perches.com, dan.carpenter@oracle.com
Subject: Re: [PATCH v2] staging: gdm7240: a TTY rewrite according to the
 latest TTY APIs
Message-ID: <20130814211200.GA4528@kroah.com>
References: <1376036357-7216-1-git-send-email-wonkang@gctsemi.com>
 <1376390761-31545-1-git-send-email-wonkang@gctsemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376390761-31545-1-git-send-email-wonkang@gctsemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 07:46:01PM +0900, Won Kang wrote:
> Removed the old style reference countings and termios.
> Renamed variables to meaninful ones.
> 
> Fixed mis-use of mutex for gdm_table. gdm_table is refered to only
> inside tty_install and port destrcut, and usb callbacks use internal
> reference which was saved during urb submission
> 
> Signed-off-by: Won Kang <wonkang@gctsemi.com>
> ---
> v2: fixed mutex bug, added ChangeLog, added missing kfree
>  drivers/staging/gdm724x/ChangeLog |   62 ++++++++

Why a changelog?  The kernel has a changelog, in the git commit log, if
every individual driver had a separate changelog, the tree would be a
mess, right?  It also looks like you included things that are already in
the kernel changelog (patches from me and others), so this is duplicated
effort.

>  drivers/staging/gdm724x/gdm_mux.c |    9 +-
>  drivers/staging/gdm724x/gdm_mux.h |   14 +-
>  drivers/staging/gdm724x/gdm_tty.c |  295 +++++++++++++++++--------------------
>  drivers/staging/gdm724x/gdm_tty.h |   36 +++--
>  5 files changed, 237 insertions(+), 179 deletions(-)
>  create mode 100644 drivers/staging/gdm724x/ChangeLog
> 
> diff --git a/drivers/staging/gdm724x/ChangeLog b/drivers/staging/gdm724x/ChangeLog
> new file mode 100644
> index 0000000..506e60e
> --- /dev/null
> +++ b/drivers/staging/gdm724x/ChangeLog
> @@ -0,0 +1,62 @@
> +2013-08-13  Won Kang <wonkang@gctsemi.com>
> +	* Fixed mis-use of mutex for gdm_table. gdm_table is refered to only
> +	* inside tty_install and port destrcut, and usb callbacks use internal
> +	* reference which was saved during urb submission
> +
> +2013-08-09  Won Kang <wonkang@gctsemi.com>
> +	* A rewrite was needed to properly use latest TTY AAPI
> +	*
> +	* Original TTY codes were written from kernel 2.6.x, doing tty reference
> +	* counting within the this driver. This is fixed to use tty core APIs.
> +	*
> +	* The usage count of tty port is no longer handled by the driver.
> +	*
> +	* termios members of tty_operations as the ports are virtual and
> +	* have no real effect.
> +	*
> +	* Renamed variables to be more clear as they were confusing due to the
> +	* similarities with the tty core structures.

Please send these two patches, not mushed together as one, so I can
apply them that way.

thanks,

greg k-h
