Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaGPUuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:50:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaGPUuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:50:52 -0400
Date: Wed, 16 Jul 2014 13:50:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Michalis Pappas <mpappas@fastmail.fm>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: conditionally compile debug code
Message-ID: <20140716205024.GA11078@kroah.com>
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm>
 <1404219616-1788-2-git-send-email-mpappas@fastmail.fm>
 <20140709185142.GA13271@kroah.com>
 <53C6E332.2070301@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C6E332.2070301@fastmail.fm>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:40:18PM +0100, Michalis Pappas wrote:
> On 07/09/2014 07:51 PM, Greg KH wrote:
> >> diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
> >> index 9d2de6f..914fd75 100644
> >> --- a/drivers/staging/gdm72xx/gdm_sdio.c
> >> +++ b/drivers/staging/gdm72xx/gdm_sdio.c
> >> @@ -280,9 +280,11 @@ static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
> >>  
> >>  	spin_unlock_irqrestore(&tx->lock, flags);
> >>  
> >> +	#if defined(GDM72xx_DEBUG)
> >>  	print_hex_dump_debug("sdio_send: ", DUMP_PREFIX_NONE, 16, 1,
> >>  			     tx->sdu_buf + TYPE_A_HEADER_SIZE,
> >>  			     aggr_len - TYPE_A_HEADER_SIZE, false);
> >> +	#endif
> > 
> > This should be moved to use dev_dbg(), along with the other calls to
> > this function in this file.
> > 
> 
> But dev_dbg() gets eventually to be printk(), which cannot print the
> buffer, so using print_hex_dump_debug() seems to be correct for this
> case, no?

No, you don't want to print the message unless debugging is enabled, and
dev_dbg() uses the proper in-kernel dynamic debug infrastructure.  There
should never be a separate config option for debugging a driver, that
ensures that no user will ever be able to help you out with it.

So delete the ifdef stuff, and the config option, and just use the
proper in-kernel infrastructure for this.

thanks,

greg k-h
