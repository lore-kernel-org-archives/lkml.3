Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaEXHEJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 03:04:09 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35247 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaEXHCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 03:02:25 -0400
From: Andrew Pinski <apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Andrew Pinski <apinski@cavium.com>
Subject: [PATCH 13/24] Drivers:input: Use is_compat_task for ARM64 also.
Date: Sat, 24 May 2014 00:02:08 -0700
Message-Id: <1400914939-9708-14-git-send-email-apinski@cavium.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1400914939-9708-1-git-send-email-apinski@cavium.com>
References: <1400914939-9708-1-git-send-email-apinski@cavium.com>
To: linux-arm-kernel@lists.infradead.org
To: linux-kernel@vger.kernel.org
To: linux-input@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since TIF_32BIT in ARM64 (with ILP32 added) is not always says if this is a compat task, we need to have the input driver understand that and use is_compat_task instead.

Thanks,
Andrew Pinski

Signed-off-by: Andrew Pinski <apinski@cavium.com>
---
 drivers/input/input-compat.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/input-compat.h b/drivers/input/input-compat.h
index 148f66f..6656957 100644
--- a/drivers/input/input-compat.h
+++ b/drivers/input/input-compat.h
@@ -19,7 +19,7 @@
 
 /* Note to the author of this code: did it ever occur to
    you why the ifdefs are needed? Think about it again. -AK */
-#if defined(CONFIG_X86_64) || defined(CONFIG_TILE)
+#if defined(CONFIG_X86_64) || defined(CONFIG_TILE) || defined(CONFIG_ARM64)
 #  define INPUT_COMPAT_TEST is_compat_task()
 #elif defined(CONFIG_S390)
 #  define INPUT_COMPAT_TEST test_thread_flag(TIF_31BIT)
-- 
1.7.2.5

