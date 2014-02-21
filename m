Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaBUUnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:43:51 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63784 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632AbaBUUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:43:48 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 3/3] staging: binder: Improve Kconfig entry for ANDROID_BINDER_IPC_32BIT
Date: Fri, 21 Feb 2014 12:43:34 -0800
Message-Id: <1393015414-12499-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393015414-12499-1-git-send-email-john.stultz@linaro.org>
References: <1393015414-12499-1-git-send-email-john.stultz@linaro.org>
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
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 3559690..1c779ef 100644
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

