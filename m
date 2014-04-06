Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaDFVnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 17:43:51 -0400
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:41867 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750935AbaDFVns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 17:43:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2282:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3872:4321:5007:7652:10004:10400:10848:11026:11232:11657:11658:11914:12043:12296:12438:12517:12519:12555:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: work33_5b39240469f32
X-Filterd-Recvd-Size: 3157
Message-ID: <1396820625.2874.23.camel@joe-AO722>
Subject: Re: [PATCH 2/2] Staging: rtl8192e: Fix sparse warning
From: Joe Perches <joe@perches.com>
To: Joel Pelaez Jorge <joelpelaez@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Apr 2014 14:43:45 -0700
In-Reply-To: <5341C760.3080508@gmail.com>
References: <5341C643.4050700@gmail.com> <5341C760.3080508@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-06 at 16:30 -0500, Joel Pelaez Jorge wrote:
> Include the header 'rtl_wx.h' to 'rtl_wx.c'
> 
> 'rtl_wx.h' has the declarations used for some source files of
> the driver. It has:
> 
> extern struct iw_handler_def r8192_wx_handlers_def;

Likely this extern should be
extern const struct iw_handler_def ...

---

 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 3 +--
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c   | 2 +-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.h   | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index c01abc2..fa087b6 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2926,8 +2926,7 @@ static int rtl8192_pci_probe(struct pci_dev *pdev,
 
 	dev->netdev_ops = &rtl8192_netdev_ops;
 
-	dev->wireless_handlers = (struct iw_handler_def *)
-				 &r8192_wx_handlers_def;
+	dev->wireless_handlers = &r8192_wx_handlers_def;
 	dev->ethtool_ops = &rtl819x_ethtool_ops;
 
 	dev->type = ARPHRD_ETHER;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 498995d..2ba5e5c 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -1320,7 +1320,7 @@ static struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 	return wstats;
 }
 
-struct iw_handler_def  r8192_wx_handlers_def = {
+const struct iw_handler_def r8192_wx_handlers_def = {
 	.standard = r8192_wx_handlers,
 	.num_standard = ARRAY_SIZE(r8192_wx_handlers),
 	.private = r8192_private_handler,
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
index 6a51a25..83747eb 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
@@ -24,7 +24,7 @@ struct net_device;
 struct iw_handler_def;
 struct iw_statistics;
 
-extern struct iw_handler_def r8192_wx_handlers_def;
+extern const struct iw_handler_def r8192_wx_handlers_def;
 struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev);
 u16 rtl8192_11n_user_show_rates(struct net_device *dev);
 


