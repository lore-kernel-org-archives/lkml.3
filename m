Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaBQV7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:59:16 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:45996 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaBQV7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:59:12 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 14/14] staging: binder: Improve Kconfig entry for ANDROID_BINDER_IPC_32BIT
Date: Mon, 17 Feb 2014 13:58:42 -0800
Message-Id: <1392674322-9036-15-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
References: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a more clear explanation of the option in the prompt, and
make the config depend on ANDROID_BINDER_IPC being selected.

Also sets the default to y, which matches AOSP.

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 78e82f5..0dc8ed7 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -21,8 +21,9 @@ config ANDROID_BINDER_IPC
 	  between said processes.
 
 config ANDROID_BINDER_IPC_32BIT
-	bool "Use old 32-bit binder api"
-	depends on !64BIT
+	bool "Use old (Android 4.4 and earlier) 32-bit binder API"
+	depends on !64BIT && ANDROID_BINDER_IPC
+	default y
 	---help---
 	  The Binder API has been changed to support both 32 and 64bit
 	  applications in a mixed environment.
-- 
1.8.3.2

