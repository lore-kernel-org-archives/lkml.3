Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaDWQWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:22:08 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:20405 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756319AbaDWQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:22:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAMAMrnV1NXQ6tr/2dsb2JhbABagwaCXqkQmWyBGRd0glMTHCMYahgkE4gtAxUByAENhlQXjECBNGSEQAEDjmyIGYFvAYpsghaFU4MzO4Es
Date: Wed, 23 Apr 2014 18:22:02 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/mtd/devices/docg3.c: add __exit to
 doc_unregister_sysfs
Message-Id: <20140423182202.1e755c243efc129aec8633f0@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

doc_unregister_sysfs is only called by __exit docg3_release

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Brian Norris <computersforpeace@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/mtd/devices/docg3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index dd5e101..eec9f39 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1636,7 +1636,7 @@ static int doc_register_sysfs(struct platform_device *pdev,
 	return ret;
 }
 
-static void doc_unregister_sysfs(struct platform_device *pdev,
+static void __exit doc_unregister_sysfs(struct platform_device *pdev,
 				 struct docg3_cascade *cascade)
 {
 	struct device *dev = &pdev->dev;
-- 
1.9.1

