Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbaIWG6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:58:38 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35646 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaIWG6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:58:37 -0400
From: Valentin Rothberg <valentinrothberg@gmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: pebolle@tiscali.nl, Valentin Rothberg <valentinrothberg@gmail.com>
Subject: [PATCH] lib: rename TEST_MODULE to TEST_LKM
Date: Tue, 23 Sep 2014 08:58:28 +0200
Message-Id: <1411455508-11958-1-git-send-email-valentinrothberg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "_MODULE" suffix is reserved for tristates compiled as
loadable kernel modules (LKM). The "TEST_MODULE" feature thereby
violates this convention. The feature is used to compile the
lib/test_module.c kernel module.

This patch renames the feature and its reference in a Makefile
to "TEST_LKM", which still expresses the test of a LKM.

Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
---
 lib/Kconfig.debug | 2 +-
 lib/Makefile      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 07c2832..db91c97 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1627,7 +1627,7 @@ config DMA_API_DEBUG
 
 	  If unsure, say N.
 
-config TEST_MODULE
+config TEST_LKM
 	tristate "Test module loading with 'hello world' module"
 	default n
 	depends on m
diff --git a/lib/Makefile b/lib/Makefile
index d6b4bc4..382437a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -31,7 +31,7 @@ obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
-obj-$(CONFIG_TEST_MODULE) += test_module.o
+obj-$(CONFIG_TEST_LKM) += test_module.o
 obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
-- 
1.9.1

