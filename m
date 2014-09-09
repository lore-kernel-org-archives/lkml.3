Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbaIIOjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:39:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36331 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbaIIOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:38:36 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 3/3] [media] vpif: Fix compilation with allmodconfig
Date: Tue,  9 Sep 2014 11:38:19 -0300
Message-Id: <c522bdd8972633e0eb481ffc5ebb7da98b190fa7.1410273306.git.m.chehab@samsung.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
In-Reply-To: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
References: <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When vpif is compiled as module, those errors happen:

ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_display.ko] undefined!
ERROR: "vpif_lock" [drivers/media/platform/davinci/vpif_capture.ko] undefined!

That's because vpif_lock symbol is not exported.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index cd08e5248387..3dad5bd7fe0a 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -38,6 +38,7 @@ MODULE_LICENSE("GPL");
 #define VPIF_CH3_MAX_MODES	2
 
 spinlock_t vpif_lock;
+EXPORT_SYMBOL_GPL(vpif_lock);
 
 void __iomem *vpif_base;
 EXPORT_SYMBOL_GPL(vpif_base);
-- 
1.9.3

