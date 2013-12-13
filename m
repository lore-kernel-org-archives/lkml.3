Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3LMW17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:27:59 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:51557 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066Ab3LMW1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:27:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: [PATCH 068/115] ion: Add Kconfig dependency to ARM
Date: Fri, 13 Dec 2013 14:24:42 -0800
Message-Id: <1386973529-4884-69-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ion code has some very specific arm-isms which keeps it
from building on other architectures. These should probably be
resolved, but in the mean time, add a dependency on CONFIG_ARM
to avoid build failures.

v2: Fix earlier flub, sending out an early untested version of
the patch.

Cc: Arve Hjønnevåg <arve@android.com>
Cc: Rebecca Schultz Zavin <rebecca@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
[jstultz: modified patch to apply to staging directory]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/staging/android/ion/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
index b5bfdb4..c62f2cb 100644
--- a/drivers/staging/android/ion/Kconfig
+++ b/drivers/staging/android/ion/Kconfig
@@ -1,5 +1,6 @@
 menuconfig ION
 	tristate "Ion Memory Manager"
+	depends on ARM
 	select GENERIC_ALLOCATOR
 	select DMA_SHARED_BUFFER
 	help
-- 
1.8.3.2

