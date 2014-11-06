Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbaKFUxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:53:49 -0500
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:57324 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751088AbaKFUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:53:46 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:3872:4321:4419:4605:5007:6117:6119:6261:7875:7903:10004:10400:10848:11026:11232:11658:11914:12114:12296:12438:12517:12519:12555:12740:13019:13069:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: birds41_20aaa80dce145
X-Filterd-Recvd-Size: 2339
Message-ID: <1415307221.21526.0.camel@perches.com>
Subject: [PATCH net-next] dccp: Convert DCCP_WARN to net_warn_ratelimited
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>
Date: Thu, 06 Nov 2014 12:53:41 -0800
In-Reply-To: <20141106.151149.1321164537677873976.davem@davemloft.net>
References: <1415230568.6634.36.camel@perches.com>
	 <1415230929.6634.38.camel@perches.com>
	 <20141106.151149.1321164537677873976.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the dependency on the "warning" sysctl (net_msg_warn)
which is only used by the LIMIT_NETDEBUG macro.

Convert the LIMIT_NETDEBUG use in DCCP_WARN to the more
common net_warn_ratelimited mechanism.

This still ratelimits based on the net_ratelimit()
function, but removes the check for the sysctl.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Thu, 2014-11-06 at 15:11 -0500, David Miller wrote:
> Applied, thanks for doing this work Joe.
No worries.

What about the LIMIT_NETDEBUG stuff now?

Maybe all of them might as well be net_dbg_ratelimited
even if it changes some of the logging levels.

Probably DCCP_WARN should be net_warn_ratelimited
so let's start there...

 net/dccp/dccp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index c678166..e4c144f 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -22,8 +22,8 @@
 /*
  * 	DCCP - specific warning and debugging macros.
  */
-#define DCCP_WARN(fmt, a...) LIMIT_NETDEBUG(KERN_WARNING "%s: " fmt,       \
-							__func__, ##a)
+#define DCCP_WARN(fmt, ...)						\
+	net_warn_ratelimited("%s: " fmt, __func__, ##__VA_ARGS__)
 #define DCCP_CRIT(fmt, a...) printk(KERN_CRIT fmt " at %s:%d/%s()\n", ##a, \
 					 __FILE__, __LINE__, __func__)
 #define DCCP_BUG(a...)       do { DCCP_CRIT("BUG: " a); dump_stack(); } while(0)



