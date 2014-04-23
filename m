Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaDWQKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:10:09 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:44437 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723AbaDWQKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:10:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8MAC7lV1NXQ6tr/2dsb2JhbABagwaCXqkQmWyBGRd0gmYcIxiBAiQTiEUBzweNdGSEQAEDjmyKCAGKbIdpgzM7gSw
Date: Wed, 23 Apr 2014 18:09:58 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 1/1] drivers/video/fbdev/omap2/dss/dss.c: add __exit to
 dss_uninit_ports
Message-Id: <20140423180958.8b3cc405c00fbbf7c6c5a947@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dss_uninit_ports is only called by __exit omap_dsshw_remove

Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/video/fbdev/omap2/dss/dss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/omap2/dss/dss.c b/drivers/video/fbdev/omap2/dss/dss.c
index d55266c..a1c1cc2 100644
--- a/drivers/video/fbdev/omap2/dss/dss.c
+++ b/drivers/video/fbdev/omap2/dss/dss.c
@@ -813,7 +813,7 @@ static int __init dss_init_ports(struct platform_device *pdev)
 	return 0;
 }
 
-static void dss_uninit_ports(void)
+static void __exit dss_uninit_ports(void)
 {
 #ifdef CONFIG_OMAP2_DSS_DPI
 	dpi_uninit_port();
-- 
1.9.1

