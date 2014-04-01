Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaDAQao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:30:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaDAQak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:30:40 -0400
Date: Tue, 1 Apr 2014 09:33:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>
Cc: linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
        Ezequiel =?iso-8859-1?Q?Garc=EDa?= 
	<ezequiel@vanguardiasur.com.ar>,
        Walter Lozano <walter@vanguardiasur.com.ar>,
        Forest Bond <forest@alittletooquiet.net>
Subject: Re: [PATCH 1/3] staging: vt6655: fix DBG_PRT and PRINT_K macros
Message-ID: <20140401163300.GB3842@kroah.com>
References: <1396356733-5344-1-git-send-email-guido@vanguardiasur.com.ar>
 <1396356733-5344-2-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396356733-5344-2-git-send-email-guido@vanguardiasur.com.ar>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 09:52:11AM -0300, Guido Martínez wrote:
> Parenthesize both macros so they will not break program logic if used
> within another 'if'. Also fix a usage of DBG_PRT with a missing
> semicolon.
> 
> Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
> ---
>  drivers/staging/vt6655/device.h | 4 ++--
>  drivers/staging/vt6655/wpactl.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
> index 062c3a3..483b017 100644
> --- a/drivers/staging/vt6655/device.h
> +++ b/drivers/staging/vt6655/device.h
> @@ -148,8 +148,8 @@
>  
>  /*---------------------  Export Types  ------------------------------*/
>  
> -#define DBG_PRT(l, p, args...) { if (l <= msglevel) printk(p, ##args); }
> -#define PRINT_K(p, args...) { if (PRIVATE_Message) printk(p, ##args); }
> +#define DBG_PRT(l, p, args...) ({ if (l <= msglevel) printk(p, ##args); })
> +#define PRINT_K(p, args...) ({ if (PRIVATE_Message) printk(p, ##args); })

I would much rather see these "fixed" by removing them entirely and
using the in-kernel calls instead (netdev_* and dev_* where applicable.)

thanks,

greg k-h
