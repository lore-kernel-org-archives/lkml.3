Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab3JWTRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:17:21 -0400
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:48673 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752461Ab3JWTPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:15:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:966:973:988:989:1260:1345:1359:1437:1534:1539:1567:1711:1714:1730:1747:1777:1792:1981:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3868:4250:4385:5007:6119:6261:10004:10026:10848:11026:11232:11658:11914:12043:12114:12296:12438:12517:12519:12555:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sugar20_69177701ab52f
X-Filterd-Recvd-Size: 1485
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH 1/8] Documentation: Remove OOM message after input_allocate_device
Date: Wed, 23 Oct 2013 12:14:47 -0700
Message-Id: <29b73e4ca6d5fb40746b20eaf9e1373bc6ab6e79.1382555436.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1382555436.git.joe@perches.com>
References: <cover.1382555436.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emitting an OOM message isn't necessary after input_allocate_device
as there's a generic OOM and a dump_stack already done.

Signed-off-by: Joe Perches <joe@perches.com>
---
 Documentation/input/input-programming.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/input/input-programming.txt b/Documentation/input/input-programming.txt
index 7f8b9d9..462390c 100644
--- a/Documentation/input/input-programming.txt
+++ b/Documentation/input/input-programming.txt
@@ -38,7 +38,6 @@ static int __init button_init(void)
 
 	button_dev = input_allocate_device();
 	if (!button_dev) {
-		printk(KERN_ERR "button.c: Not enough memory\n");
 		error = -ENOMEM;
 		goto err_free_irq;
 	}
-- 
1.8.1.2.459.gbcd45b4.dirty

