Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab3CNJlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:41:42 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:58925 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856Ab3CNJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:41:41 -0400
Message-ID: <1363254099.1335.38.camel@x61.thuisdomein>
Subject: [PATCH] staging: android: remove dependency on TINY_SHMEM
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 10:41:39 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Mar 2013 09:41:39.0455 (UTC) FILETIME=[209C38F0:01CE2098]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for the "Anonymous Shared Memory Subsystem" got added
in v3.3. It has an optional dependency on TINY_SHMEM. But TINY_SHMEM had
already been removed in v2.6.29. So this optional dependency can safely
be removed too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/staging/android/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 465a28c..ae575ee 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -22,7 +22,7 @@ config ANDROID_BINDER_IPC
 config ASHMEM
 	bool "Enable the Anonymous Shared Memory Subsystem"
 	default n
-	depends on SHMEM || TINY_SHMEM
+	depends on SHMEM
 	---help---
 	  The ashmem subsystem is a new shared memory allocator, similar to
 	  POSIX SHM but with different behavior and sporting a simpler
-- 
1.7.11.7

