Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbaDXK4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:56:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaDXIxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/182] mfd: Include all drivers in subsystem menu
Date: Thu, 24 Apr 2014 09:49:53 +0100
Message-Id: <1398329507-5911-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index aecd6dd..3ebc6c1 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1145,8 +1145,6 @@ config MFD_WM8994
 	  core support for the WM8994, in order to use the actual
 	  functionaltiy of the device other drivers must be enabled.
 
-endmenu
-endif
 
 menu "Multimedia Capabilities Port drivers"
 	depends on ARCH_SA1100
@@ -1178,3 +1176,6 @@ config VEXPRESS_CONFIG
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
 	  Versatile Express.
+
+endmenu
+endif
-- 
1.9.1

