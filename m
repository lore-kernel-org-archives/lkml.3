Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaBCSQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:16:34 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45103 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaBCSQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:16:33 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Greg Hackmann <ghackmann@google.com>,
        Prakash Kamliya <pkamliya@codeaurora.org>,
        Alistair Strachan <alistair.strachan@imgtec.com>,
        Todd Poynor <toddpoynor@google.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 00/16] [RFC] Staging updates from the Android tree
Date: Mon,  3 Feb 2014 10:16:12 -0800
Message-Id: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently went through the AOSP common.git android/3.10 tree to
try to pull fixes that haven't been submitted upstream. I've
cherry picked those patches and wanted to submit them here for
review, and for hopeful inclusion into staging for 3.15.

In most cases the patches cherry-picked right over. In a few cases,
there were collisions due to trivial changes and cleanups like
spelling fixes. However, the "ion: Move shrinker out of heaps"
patch required more complicated merge, due to the shrinker api
change upstream in 3.12.  Things build and appear to work, but
I'd appreciate extra review there.

Anyway, please let me know if there's any feedback or suggestions. 

thanks
-john

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Prakash Kamliya <pkamliya@codeaurora.org>
Cc: Alistair Strachan <alistair.strachan@imgtec.com>
Cc: Todd Poynor <toddpoynor@google.com>
Cc: Mitchel Humpherys <mitchelh@codeaurora.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Android Kernel Team <kernel-team@android.com>


Alistair Strachan (1):
  staging: sync: Fix a race condition between release_obj and print_obj

Colin Cross (6):
  staging: android: Split uapi out of android_alarm.h
  staging: android: Split uapi out of ashmem.h
  staging: android: split uapi out of sync.h and sw_sync.h
  staging: android: Split uapi out of binder.h
  staging: ion: Fix overflow and list bugs in system heap
  staging: ion: Move shrinker out of heaps

Greg Hackmann (1):
  staging: sw_sync: Add stubs for kernels without CONFIG_SW_SYNC

Laura Abbott (2):
  staging: ion: Fix debugfs handling of multiple kernel clients
  staging: ion: Fix ION_IOC_FREE compat ioctl

Mitchel Humpherys (4):
  staging: ion: Create separate heap and client debugfs directories
  staging: ion: Store a copy of the client name on client creation
  staging: ion: Make sure all clients are exposed in debugfs
  staging: ion: Add private buffer flag to skip page pooling on free

Prakash Kamliya (1):
  staging: sync: Signal pt before sync_timeline object gets destroyed

Todd Poynor (1):
  staging: ashmem: Avoid deadlock between read and mmap calls

 drivers/staging/android/android_alarm.h       |  44 +---
 drivers/staging/android/ashmem.c              |  45 ++--
 drivers/staging/android/ashmem.h              |  30 +--
 drivers/staging/android/binder.h              | 306 +-----------------------
 drivers/staging/android/ion/compat_ion.c      |  26 +-
 drivers/staging/android/ion/ion.c             | 121 ++++++++--
 drivers/staging/android/ion/ion_heap.c        |  65 ++++-
 drivers/staging/android/ion/ion_page_pool.c   |   8 +-
 drivers/staging/android/ion/ion_priv.h        |  63 ++++-
 drivers/staging/android/ion/ion_system_heap.c |  90 ++-----
 drivers/staging/android/sw_sync.h             |  37 +--
 drivers/staging/android/sync.c                |  14 +-
 drivers/staging/android/sync.h                |  86 +------
 drivers/staging/android/uapi/android_alarm.h  |  62 +++++
 drivers/staging/android/uapi/ashmem.h         |  47 ++++
 drivers/staging/android/uapi/binder.h         | 330 ++++++++++++++++++++++++++
 drivers/staging/android/uapi/sw_sync.h        |  32 +++
 drivers/staging/android/uapi/sync.h           |  97 ++++++++
 18 files changed, 895 insertions(+), 608 deletions(-)
 create mode 100644 drivers/staging/android/uapi/android_alarm.h
 create mode 100644 drivers/staging/android/uapi/ashmem.h
 create mode 100644 drivers/staging/android/uapi/binder.h
 create mode 100644 drivers/staging/android/uapi/sw_sync.h
 create mode 100644 drivers/staging/android/uapi/sync.h

-- 
1.8.3.2

