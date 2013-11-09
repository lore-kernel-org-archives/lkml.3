Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab3KILXl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 06:23:41 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:56954 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3KILXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 06:23:39 -0500
From: Baptiste Covolato <b.covolato@gmail.com>
To: greg@kroah.com
Cc: swetland@google.com, linux-kernel@vger.kernel.org,
        Baptiste Covolato <b.covolato@gmail.com>
Subject: [PATCH] Staging: android: Add possibility to compile android drivers as modules
Date: Sat,  9 Nov 2013 14:23:42 +0100
Message-Id: <1384003422-24683-1-git-send-email-b.covolato@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compilation of Android staging drivers as drivers is now possible.

Signed-off-by: Baptiste Covolato <b.covolato@gmail.com>
---
 drivers/staging/android/Kconfig | 18 +++++++++---------
 drivers/staging/android/TODO    |  1 -
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 1e9ab6d..a22737d 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -1,7 +1,7 @@
 menu "Android"
 
 config ANDROID
-	bool "Android Drivers"
+	tristate "Android Drivers"
 	default N
 	---help---
 	  Enable support for various drivers needed on the Android platform
@@ -9,7 +9,7 @@ config ANDROID
 if ANDROID
 
 config ANDROID_BINDER_IPC
-	bool "Android Binder IPC Driver"
+	tristate "Android Binder IPC Driver"
 	depends on MMU
 	default n
 	---help---
@@ -21,7 +21,7 @@ config ANDROID_BINDER_IPC
 	  between said processes.
 
 config ASHMEM
-	bool "Enable the Anonymous Shared Memory Subsystem"
+	tristate "Enable the Anonymous Shared Memory Subsystem"
 	default n
 	depends on SHMEM
 	---help---
@@ -50,7 +50,7 @@ config ANDROID_LOGGER
 	  much overhead in the system.
 
 config ANDROID_TIMED_OUTPUT
-	bool "Timed output class driver"
+	tristate "Timed output class driver"
 	default y
 
 config ANDROID_TIMED_GPIO
@@ -59,13 +59,13 @@ config ANDROID_TIMED_GPIO
 	default n
 
 config ANDROID_LOW_MEMORY_KILLER
-	bool "Android Low Memory Killer"
+	tristate "Android Low Memory Killer"
 	default N
 	---help---
 	  Registers processes to be killed when memory is low
 
 config ANDROID_INTF_ALARM_DEV
-	bool "Android alarm driver"
+	tristate "Android alarm driver"
 	depends on RTC_CLASS
 	default n
 	---help---
@@ -74,7 +74,7 @@ config ANDROID_INTF_ALARM_DEV
 	  Also exports the alarm interface to user-space.
 
 config SYNC
-	bool "Synchronization framework"
+	tristate "Synchronization framework"
 	default n
 	select ANON_INODES
 	---help---
@@ -83,7 +83,7 @@ config SYNC
 	  synchronization built into devices like GPUs.
 
 config SW_SYNC
-	bool "Software synchronization objects"
+	tristate "Software synchronization objects"
 	default n
 	depends on SYNC
 	---help---
@@ -92,7 +92,7 @@ config SW_SYNC
 	  the synchronization.
 
 config SW_SYNC_USER
-	bool "Userspace API for SW_SYNC"
+	tristate "Userspace API for SW_SYNC"
 	default n
 	depends on SW_SYNC
 	---help---
diff --git a/drivers/staging/android/TODO b/drivers/staging/android/TODO
index b15fb0d..9b7394a 100644
--- a/drivers/staging/android/TODO
+++ b/drivers/staging/android/TODO
@@ -2,7 +2,6 @@ TODO:
 	- checkpatch.pl cleanups
 	- sparse fixes
 	- rename files to be not so "generic"
-	- make sure things build as modules properly
 	- add proper arch dependencies as needed
 	- audit userspace interfaces to make sure they are sane
 
-- 
1.8.4.2

