Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbaGDSrd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 14:47:33 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:43129 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbaGDSrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 14:47:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAMADz2tlNbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BmWeBCxd1hGAjgRo3iEYBtU6VCxeFcIkyHYQtBZAJim2LTIhAg0U7
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org
Subject: [PATCH 1/1] arch/sh/kernel/time.c: use PTR_ERR_OR_ZERO
Date: Fri,  4 Jul 2014 20:47:28 +0200
Message-Id: <1404499648-14414-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace IS_ERR/PTR_ERR

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-sh@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 arch/sh/kernel/time.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index 552c8fc..d6d0a98 100644
--- a/arch/sh/kernel/time.c
+++ b/arch/sh/kernel/time.c
@@ -80,10 +80,8 @@ static int __init rtc_generic_init(void)
 		return -ENODEV;
 
 	pdev = platform_device_register_simple("rtc-generic", -1, NULL, 0);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
 
-	return 0;
+	return PTR_ERR_OR_ZERO(pdev);
 }
 module_init(rtc_generic_init);
 
-- 
1.9.1

