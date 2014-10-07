Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbaJGPkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:40:47 -0400
Received: from mail-by2on0122.outbound.protection.outlook.com ([207.46.100.122]:59254
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754382AbaJGPko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:40:44 -0400
From: Cristian Stoica <cristian.stoica@freescale.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <hjk@hansjkoch.de>
CC: Cristian Stoica <cristian.stoica@freescale.com>
Subject: [PATCH 1/2] devres: support sizes greater than an unsigned long
Date: Tue, 7 Oct 2014 18:25:43 +0300
Message-ID: <1412695544-17251-1-git-send-email-cristian.stoica@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(229853001)(107046002)(81156004)(95666004)(77156001)(87286001)(89996001)(80022003)(87936001)(105606002)(575784001)(50986999)(106466001)(104166001)(33646002)(104016003)(97736003)(99396003)(76482002)(120916001)(62966002)(85852003)(21056001)(31966008)(88136002)(36756003)(46102003)(93916002)(68736004)(102836001)(2201001)(47776003)(20776003)(26826002)(92726001)(64706001)(92566001)(85306004)(50226001)(48376002)(50466002)(19580405001)(19580395003)(44976005)(6806004)(69596002)(4396001)(84676001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0620;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0620;
X-Forefront-PRVS: 035748864E
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=B18196@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As in 4f452e8aa492c0b8028ca9b4bdb4d018ba28c6c7, use resource_size_t
to accomodate sizes greater than the size of an unsigned long int on
platforms that have more than 32 bit physical addresses.

Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
---
 include/linux/io.h | 4 ++--
 lib/devres.c       | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index d5fc9b8..fa02e55 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -61,9 +61,9 @@ static inline void devm_ioport_unmap(struct device *dev, void __iomem *addr)
 #define IOMEM_ERR_PTR(err) (__force void __iomem *)ERR_PTR(err)
 
 void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
-			    unsigned long size);
+			   resource_size_t size);
 void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
-				    unsigned long size);
+				   resource_size_t size);
 void devm_iounmap(struct device *dev, void __iomem *addr);
 int check_signature(const volatile void __iomem *io_addr,
 			const unsigned char *signature, int length);
diff --git a/lib/devres.c b/lib/devres.c
index f4a195a..0f1dd2e 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -23,7 +23,7 @@ static int devm_ioremap_match(struct device *dev, void *res, void *match_data)
  * Managed ioremap().  Map is automatically unmapped on driver detach.
  */
 void __iomem *devm_ioremap(struct device *dev, resource_size_t offset,
-			   unsigned long size)
+			   resource_size_t size)
 {
 	void __iomem **ptr, *addr;
 
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(devm_ioremap);
  * detach.
  */
 void __iomem *devm_ioremap_nocache(struct device *dev, resource_size_t offset,
-				   unsigned long size)
+				   resource_size_t size)
 {
 	void __iomem **ptr, *addr;
 
-- 
1.8.3.1

