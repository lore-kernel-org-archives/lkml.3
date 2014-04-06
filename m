Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbaDFStg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 14:49:36 -0400
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:33233 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754207AbaDFStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 14:49:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:334:355:368:369:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:4321:5007:7514:7652:8957:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: root60_18fe30361ee56
X-Filterd-Recvd-Size: 2332
Message-ID: <1396810170.2874.9.camel@joe-AO722>
Subject: Re: [PATCH v2] Staging: rtl8192e: Fix sparse warning
From: Joe Perches <joe@perches.com>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 11:49:30 -0700
In-Reply-To: <5341A05A.5080403@gmail.com>
References: <5341A05A.5080403@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 13:43 -0500, Joel Pelaez Jorge wrote:
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
>   {
>   	struct r8192_priv *priv = rtllib_priv(dev);
>   	struct rtllib_device *ieee = priv->rtllib;

As far as I can tell, there's no reason this should
be declared in the .h file and it should stay static
and not be exposed at all.


