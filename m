Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaB0CIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 21:08:46 -0500
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:45143 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752649AbaB0CIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 21:08:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1515:1516:1518:1534:1538:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3871:3876:4321:5007:6120:7652:10004:10400:10848:11232:11658:11914:12517:12519:12555:13069:13311:13357:13848,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: floor33_866d50e4e0e41
X-Filterd-Recvd-Size: 1459
Message-ID: <1393466922.24588.68.camel@joe-AO722>
Subject: [RFC PATCH] Makefile: sparse - don't check sizeof(bool)
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 26 Feb 2014 18:08:42 -0800
In-Reply-To: <1393466619.24588.65.camel@joe-AO722>
References: <530E6F76.1070605@zytor.com>
	 <1393462087.24588.50.camel@joe-AO722> <530E8C2E.7080307@zytor.com>
	 <1393466619.24588.65.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an override for sizeof(bool)

Requires sparse 0.5.0+ if -Wsizeof-bool is accepted there.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index fce2ba7..d9cea07 100644
--- a/Makefile
+++ b/Makefile
@@ -350,7 +350,7 @@ PERL		= perl
 CHECK		= sparse
 
 CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
-		  -Wbitwise -Wno-return-void $(CF)
+		  -Wbitwise -Wno-return-void -Wno-sizeof-bool $(CF)
 CFLAGS_MODULE   =
 AFLAGS_MODULE   =
 LDFLAGS_MODULE  =


