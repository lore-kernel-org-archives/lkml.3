Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaBQV6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:58:53 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:64749 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaBQV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:58:51 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 00/14][RFC] Android updates for staging-next
Date: Mon, 17 Feb 2014 13:58:28 -0800
Message-Id: <1392674322-9036-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently went through the Android AOSP common tree and
cherry-picked out a number of changes that haven't yet
been submitted upstream.

I wanted to send them out for comment and potential
merging for 3.15 via staging-next.

Few minor notes:
* The first patch in the series (binder: Fix death notifications)
  could potentially be merged in 3.14 as a fix.

* The binder ABI change patch had a large number of checkpatch
  warnings for columns over 80 chars. I've fixed most of them,
  but the remaining are all strings, which I don't have a good
  sense of how to best address (splitting the string also give
  warnings).

* The only other unaddressed checkpatch issue is:
  WARNING: __packed is preferred over __attribute__((packed))
  But I'm hesitant to change that as this is a uapi .h file and
  I'm not sure if __packed is defined in userspace.

* The last patch isn't yet submitted to AOSP, but it seemed obvious
  enough and if there's no objections I'll submit it shortly.

Comments, thoughts, suggestions?

thanks
-john

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Android Kernel Team <kernel-team@android.com>

Arve Hjønnevåg (2):
  staging: binder: Fix death notifications
  staging: binder: Support concurrent 32 bit and 64 bit processes.

Colin Cross (5):
  staging: android: Split uapi out of android_alarm.h
  staging: android: Split uapi out of ashmem.h
  staging: android: split uapi out of sync.h and sw_sync.h
  staging: android: Split uapi out of binder.h
  staging: ion: Move shrinker out of heaps

John Stultz (1):
  staging: binder: Improve Kconfig entry for ANDROID_BINDER_IPC_32BIT

Laura Abbott (1):
  staging: ion: Fix debugfs handling of multiple kernel clients

Mitchel Humpherys (4):
  staging: ion: Create separate heap and client debugfs directories
  staging: ion: Store a copy of the client name on client creation
  staging: ion: Make sure all clients are exposed in debugfs
  staging: ion: Add private buffer flag to skip page pooling on free

Serban Constantinescu (1):
  staging: binder: Fix ABI for 64bit Android

 drivers/staging/android/Kconfig               |  13 +
 drivers/staging/android/android_alarm.h       |  44 +---
 drivers/staging/android/ashmem.h              |  30 +--
 drivers/staging/android/binder.c              | 271 +++++++++++---------
 drivers/staging/android/binder.h              | 308 +---------------------
 drivers/staging/android/binder_trace.h        |  14 +-
 drivers/staging/android/ion/ion.c             | 121 +++++++--
 drivers/staging/android/ion/ion_heap.c        |  65 ++++-
 drivers/staging/android/ion/ion_page_pool.c   |   8 +-
 drivers/staging/android/ion/ion_priv.h        |  63 ++++-
 drivers/staging/android/ion/ion_system_heap.c |  84 ++----
 drivers/staging/android/sw_sync.h             |  20 +-
 drivers/staging/android/sync.h                |  86 +------
 drivers/staging/android/uapi/android_alarm.h  |  62 +++++
 drivers/staging/android/uapi/ashmem.h         |  47 ++++
 drivers/staging/android/uapi/binder.h         | 351 ++++++++++++++++++++++++++
 drivers/staging/android/uapi/sw_sync.h        |  32 +++
 drivers/staging/android/uapi/sync.h           |  97 +++++++
 18 files changed, 1014 insertions(+), 702 deletions(-)
 create mode 100644 drivers/staging/android/uapi/android_alarm.h
 create mode 100644 drivers/staging/android/uapi/ashmem.h
 create mode 100644 drivers/staging/android/uapi/binder.h
 create mode 100644 drivers/staging/android/uapi/sw_sync.h
 create mode 100644 drivers/staging/android/uapi/sync.h

-- 
1.8.3.2

