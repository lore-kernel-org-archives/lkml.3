Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaCVU7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:59:16 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62551 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaCVU7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:59:14 -0400
Date: Sat, 22 Mar 2014 13:59:10 -0700
From: John de la Garza <john@jjdev.com>
To: linux-kernel@vger.kernel.org
Cc: standby24x7@gmail.com, gregkh@linuxfoundation.org
Subject: [PATCH] drivers:staging:crystalhd Fixes sparse warning about
 incorrect type
Message-ID: <20140322205907.GA4535@vega.socal.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes these sparse warnings:
drivers/staging/crystalhd/crystalhd_lnx.c:507:30: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/crystalhd/crystalhd_lnx.c:507:30:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/crystalhd/crystalhd_lnx.c:507:30:    got void *addr
drivers/staging/crystalhd/crystalhd_lnx.c:510:30: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/crystalhd/crystalhd_lnx.c:510:30:    expected void volatile [noderef] <asn:2>*addr
drivers/staging/crystalhd/crystalhd_lnx.c:510:30:    got void *i2o_addr

Signed-off-by: John de la Garza <john@jjdev.com>
---
 drivers/staging/crystalhd/crystalhd_lnx.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index 816e1cd..49e1ef3 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -58,11 +58,11 @@ struct crystalhd_adp {
 
 	unsigned long		pci_mem_start;
 	uint32_t		pci_mem_len;
-	void			*addr;
+	void __iomem		*addr;
 
 	unsigned long		pci_i2o_start;
 	uint32_t		pci_i2o_len;
-	void			*i2o_addr;
+	void __iomem		*i2o_addr;
 
 	unsigned int		drv_data;
 	unsigned int		dmabits;	/* 32 | 64 */
-- 
1.9.0

