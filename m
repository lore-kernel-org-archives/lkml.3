Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbaFSFOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:14:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaFSFOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:14:15 -0400
Date: Wed, 18 Jun 2014 22:14:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Seunghun Lee <waydi1@gmail.com>
Cc: devel@driverdev.osuosl.org, alois.schloegl@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ced1401: fix sparse warning for ced1401
Message-ID: <20140619051406.GA7564@kroah.com>
References: <1402722278-23040-1-git-send-email-waydi1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402722278-23040-1-git-send-email-waydi1@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2014 at 02:04:38PM +0900, Seunghun Lee wrote:
> This patch fixes below warning.
> 
> drivers/staging/ced1401/ced_ioc.c:703:30: warning: incorrect type in assignment (different address spaces)
> 	drivers/staging/ced1401/ced_ioc.c:703:30:    expected void *[usertype] lpvBuff
> 	drivers/staging/ced1401/ced_ioc.c:703:30:    got char [noderef] <asn:1>*puBuf
> 
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  drivers/staging/ced1401/ced_ioc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
> index ebbc509..963b941 100644
> --- a/drivers/staging/ced1401/ced_ioc.c
> +++ b/drivers/staging/ced1401/ced_ioc.c
> @@ -700,7 +700,7 @@ static int SetArea(DEVICE_EXTENSION *pdx, int nArea, char __user *puBuf,
>  		/*  kmap() or kmap_atomic() to get a virtual address. page_address will give you */
>  		/*  (null) or at least it does in this context with an x86 machine. */
>  		spin_lock_irq(&pdx->stagedLock);
> -		pTA->lpvBuff = puBuf;	/*  keep start of region (user address) */
> +		pTA->lpvBuff = (__force void *)puBuf;	/*  keep start of region (user address) */

Shouldn't you change the type of lpvBuff instead of having to force this
cast?

thanks,

greg k-h
