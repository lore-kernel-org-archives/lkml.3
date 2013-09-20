Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3ITSXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:23:38 -0400
Received: from smtprelay0096.hostedemail.com ([216.40.44.96]:46439 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753314Ab3ITSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:23:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3870:3871:4321:5007:6261:7903:10004:10026:10848:11658:11914:12043:12438:12517:12519:12555:13161:13229:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: frogs05_3c2b188566420
X-Filterd-Recvd-Size: 2011
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] dcbevent.h: Remove extern from function prototypes
Date: Fri, 20 Sep 2013 11:23:19 -0700
Message-Id: <346f461ada19cda69e1843c2c119f54f8def4cb1.1379701322.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <597c1b62607f823af60dc4a99d59373dddfb7837.1379701322.git.joe@perches.com>
References: <597c1b62607f823af60dc4a99d59373dddfb7837.1379701322.git.joe@perches.com>
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
 include/net/dcbevent.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/dcbevent.h b/include/net/dcbevent.h
index 443626e..d2f3041 100644
--- a/include/net/dcbevent.h
+++ b/include/net/dcbevent.h
@@ -25,9 +25,9 @@ enum dcbevent_notif_type {
 };
 
 #ifdef CONFIG_DCB
-extern int register_dcbevent_notifier(struct notifier_block *nb);
-extern int unregister_dcbevent_notifier(struct notifier_block *nb);
-extern int call_dcbevent_notifiers(unsigned long val, void *v);
+int register_dcbevent_notifier(struct notifier_block *nb);
+int unregister_dcbevent_notifier(struct notifier_block *nb);
+int call_dcbevent_notifiers(unsigned long val, void *v);
 #else
 static inline int
 register_dcbevent_notifier(struct notifier_block *nb)
-- 
1.8.1.2.459.gbcd45b4.dirty

