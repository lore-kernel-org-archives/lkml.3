Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3IKEaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19387 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab3IKE3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:02 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=dRVUMsx45IIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=2-Ivz3iTORwA:10 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=SFncbC_4GEwA:10 a=3Rfx1nUSh_UA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=0BWcnzhK_fYA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042856.757671831@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [027/251] b43: ensue that BCMA is "y" when B43 is "y"
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0027-b43-ensue-that-BCMA-is-y-when-B43-is-y.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit 693026ef2e751fd94d2e6c71028e68343cc875d5 ]

When b43 gets build into the kernel and it should use bcma we have to
ensure that bcma was also build into the kernel and not as a module.
In this patch this is also done for SSB, although you can not
build b43 without ssb support for now.

This fixes a build problem reported by Randy Dunlap in
5187EB95.2060605@infradead.org

Reported-By: Randy Dunlap <rdunlap@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/b43/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 3876c7e..af40211 100644
--- a/drivers/net/wireless/b43/Kconfig
+++ b/drivers/net/wireless/b43/Kconfig
@@ -28,7 +28,7 @@ config B43
 
 config B43_BCMA
 	bool "Support for BCMA bus"
-	depends on B43 && BCMA
+	depends on B43 && (BCMA = y || BCMA = B43)
 	default y
 
 config B43_BCMA_EXTRA
@@ -39,7 +39,7 @@ config B43_BCMA_EXTRA
 
 config B43_SSB
 	bool
-	depends on B43 && SSB
+	depends on B43 && (SSB = y || SSB = B43)
 	default y
 
 # Auto-select SSB PCI-HOST support, if possible
-- 
1.7.10.4


