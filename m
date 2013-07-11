Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3GKOiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:38:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43156 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968Ab3GKO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 68/98] b43: ensue that BCMA is "y" when B43 is "y"
Date: Thu, 11 Jul 2013 15:24:38 +0100
Message-Id: <1373552708-15235-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hauke Mehrtens <hauke@hauke-m.de>

commit 693026ef2e751fd94d2e6c71028e68343cc875d5 upstream.

When b43 gets build into the kernel and it should use bcma we have to
ensure that bcma was also build into the kernel and not as a module.
In this patch this is also done for SSB, although you can not
build b43 without ssb support for now.

This fixes a build problem reported by Randy Dunlap in
5187EB95.2060605@infradead.org

Reported-By: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/b43/Kconfig | 4 ++--
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
1.8.1.2

