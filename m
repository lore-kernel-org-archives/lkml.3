Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaGISrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:47:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbaGISrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:47:17 -0400
Date: Wed, 9 Jul 2014 11:51:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: conditionally compile debug code
Message-ID: <20140709185142.GA13271@kroah.com>
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
 <1404219616-1788-2-git-send-email-mpappas@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404219616-1788-2-git-send-email-mpappas@fastmail.fm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:00:15PM +0100, Michalis Pappas wrote:
> Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
> ---
>  drivers/staging/gdm72xx/gdm_qos.c   | 2 ++
>  drivers/staging/gdm72xx/gdm_sdio.c  | 7 +++++++
>  drivers/staging/gdm72xx/gdm_usb.c   | 7 +++++++
>  drivers/staging/gdm72xx/gdm_wimax.c | 6 ++++++
>  drivers/staging/gdm72xx/gdm_wimax.h | 2 ++
>  5 files changed, 24 insertions(+)
> 
> diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
> index b08c8e1..7900981 100644
> --- a/drivers/staging/gdm72xx/gdm_qos.c
> +++ b/drivers/staging/gdm72xx/gdm_qos.c
> @@ -88,7 +88,9 @@ static void free_qos_entry_list(struct list_head *free_list)
>  		total_free++;
>  	}
>  
> +	#if defined(GDM72xx_DEBUG)
>  	pr_debug("%s: total_free_cnt=%d\n", __func__, total_free);
> +	#endif

Ick, no, never put #ifdef in .c code if you can help it.  For stuff like
this, just rely on the dynamic debug core and use the pr_debug and
dev_dbg() calls, like the driver is doing, so all should be fine.

> diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
> index 9d2de6f..914fd75 100644
> --- a/drivers/staging/gdm72xx/gdm_sdio.c
> +++ b/drivers/staging/gdm72xx/gdm_sdio.c
> @@ -280,9 +280,11 @@ static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
>  
>  	spin_unlock_irqrestore(&tx->lock, flags);
>  
> +	#if defined(GDM72xx_DEBUG)
>  	print_hex_dump_debug("sdio_send: ", DUMP_PREFIX_NONE, 16, 1,
>  			     tx->sdu_buf + TYPE_A_HEADER_SIZE,
>  			     aggr_len - TYPE_A_HEADER_SIZE, false);
> +	#endif

This should be moved to use dev_dbg(), along with the other calls to
this function in this file.

thanks,

greg k-h
