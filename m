Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab3GOO1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:27:55 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:54479 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab3GOO1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:27:52 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH-v3 05/17] stating/lustre: only build if configured as module
Date: Mon, 15 Jul 2013 22:27:08 +0800
Message-Id: <1373898440-14208-6-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
References: <1373898440-14208-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

Lustre internal dependency needs to be cleaned up. Currently,
libcfs is acting as a basis of all other modules, while other
modules in lustre/ directory in turn depend on lnet modules.
It creates a dependency loop that need to be fixed. Hopefully
we will remove libcfs in the end. So just disable buildin for
now.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index e0eb830..c59ea55 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -1,6 +1,6 @@
 config LUSTRE_FS
 	tristate "Lustre file system client support"
-	depends on STAGING && INET && BROKEN
+	depends on STAGING && INET && m && BROKEN
 	select LNET
 	select CRYPTO
 	select CRYPTO_CRC32
-- 
1.7.9.5

