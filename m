Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaDFS7R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 14:59:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbaDFS7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 14:59:16 -0400
Date: Sun, 6 Apr 2014 12:01:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Silvan Jegen <s.jegen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: rtl8192e: Fix sparse warning
Message-ID: <20140406190145.GB30469@kroah.com>
References: <5341A05A.5080403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5341A05A.5080403@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2014 at 01:43:38PM -0500, Joel Pelaez Jorge wrote:
> Fix a sparse warning, non static symbol is no declared as such.
> And fix a conflict with static function declared extern to include
> rtl_wx.h header.
> 
> drivers/staging/rtl8192e/rtl8192e/rtl_wx.c:1323:24: warning:
> symbol 'r8192_wx_handlers_def' was not declared. Should it be static?
> 
> Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
> ---
>   drivers/staging/rtl8192e/rtl8192e/rtl_wx.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c 
> b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> index 498995d..f17584d 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> @@ -19,6 +19,7 @@
> 
>   #include <linux/string.h>
>   #include "rtl_core.h"
> +#include "rtl_wx.h"

Why is this needed?

> 
>   #define RATE_COUNT 12
>   static u32 rtl8192_rates[] = {
> @@ -1293,7 +1294,7 @@ static iw_handler r8192_private_handler[] = {
>   	(iw_handler)r8192_wx_get_PromiscuousMode,
>   };
> 
> -static struct iw_statistics *r8192_get_wireless_stats(struct net_device 
> *dev)
> +struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)

Why make this global?  This doesn't have anything to do with the warning
you are working on as described above.

totally confused,

greg k-h
