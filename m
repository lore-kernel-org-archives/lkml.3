Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3IVRdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:33:08 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:34301 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752994Ab3IVRcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:32:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1540:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:5007:6261:7903:10004:10026:10848:11658:11914:12438:12517:12519:12555:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rake13_1850c2e9ec918
X-Filterd-Recvd-Size: 1771
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] stp.h: Remove extern from function prototypes
Date: Sun, 22 Sep 2013 10:32:27 -0700
Message-Id: <9d2d9954458b6bc4b4538c883124a76c1bc7aba7.1379870986.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
References: <b692aba58032f629907ea2d462c99b87906645ca.1379870986.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a mix of function prototypes with and without extern
in the kernel sources.  Standardize on not using extern for
function prototypes.

Function prototypes don't need to be written with extern.
extern is assumed by the compiler.  Its use is as unnecessary as
using auto to declare automatic/local variables in a block.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/stp.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/stp.h b/include/net/stp.h
index ad447f1..3af174d 100644
--- a/include/net/stp.h
+++ b/include/net/stp.h
@@ -8,7 +8,7 @@ struct stp_proto {
 	void		*data;
 };
 
-extern int stp_proto_register(const struct stp_proto *proto);
-extern void stp_proto_unregister(const struct stp_proto *proto);
+int stp_proto_register(const struct stp_proto *proto);
+void stp_proto_unregister(const struct stp_proto *proto);
 
 #endif /* _NET_STP_H */
-- 
1.8.1.2.459.gbcd45b4.dirty

