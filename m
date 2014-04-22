Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbaDVUkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:40:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189AbaDVUYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 078/133] mfd: Include all drivers in subsystem menu
Date: Tue, 22 Apr 2014 13:13:36 -0700
Message-Id: <1398197671-12786-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

commit a6e6e660baa5c583022e3e48c85316bace027825 upstream.

It is currently not possible to select the SA1100 or Vexpress
drivers in the MFD subsystem, because the menu for the entire
subsystem ends before these options are presented.

Move the main menu closing and the endif for HAS_IOMEM to the
end of the file so these are selectable again.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ff553ba..d102685 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1114,9 +1114,6 @@ config MFD_AS3711
 	help
 	  Support for the AS3711 PMIC from AMS
 
-endmenu
-endif
-
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
 
@@ -1146,3 +1143,6 @@ config VEXPRESS_CONFIG
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
 	  Versatile Express.
+
+endmenu
+endif
-- 
1.9.1

