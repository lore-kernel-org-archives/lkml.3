Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaBZW3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:29:35 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35293 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaBZW3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:29:34 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [RFC][PATCH] staging: Fix build issues with new binder API
Date: Wed, 26 Feb 2014 14:29:07 -0800
Message-Id: <1393453747-12513-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new 64bit binder API causes build issues on 32bit ARM
due to the lack of 64bit __get_user_asm_* implementation.

Until that implementation is done, remove the choice for
32bit ARM, automatically enabling the old 32bit binder
protocol.

This can be reverted once a 64bit __get_user_asm_*
implementation is merged.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>
Reported-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 1c779ef..ab28d2b 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -21,7 +21,7 @@ config ANDROID_BINDER_IPC
 	  between said processes.
 
 config ANDROID_BINDER_IPC_32BIT
-	bool "Use old (Android 4.4 and earlier) 32-bit binder API"
+	bool
 	depends on !64BIT && ANDROID_BINDER_IPC
 	default y
 	---help---
-- 
1.8.3.2

