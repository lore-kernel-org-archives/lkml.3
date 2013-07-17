Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462Ab3GQXQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:16:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56560 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934422Ab3GQWzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 095/145] b43: ensue that BCMA is "y" when B43 is "y"
Date: Wed, 17 Jul 2013 15:47:07 -0700
Message-Id: <1374101277-7915-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/b43/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
index 7a28d21..9c927be 100644
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

