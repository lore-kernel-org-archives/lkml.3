Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbaBEAJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:09:15 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64057 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaBEAJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:09:12 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Greg Hackmann <ghackmann@google.com>,
        Prakash Kamliya <pkamliya@codeaurora.org>,
        Alistair Strachan <alistair.strachan@imgtec.com>,
        Todd Poynor <toddpoynor@google.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCHv2 0/7] Staging fixes from the Android tree (for 3.14)
Date: Tue,  4 Feb 2014 16:08:33 -0800
Message-Id: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently went through the AOSP common.git android/3.10 tree to
try to pull fixes that haven't been submitted upstream. I've
cherry picked those patches and submitted them for 3.15, but
Greg requested the bugfixes to be submitted by themselves for
3.14.

So here are the subset of changes that are bugfixes. There is
one additional patch here which I missed in my last submission,
but its a build warning fix, so I think its appropriate.

If and when these are merged, I'll resubmit the rest of the
queue (which has grown further as of today) for 3.15.

Anyway, please let me know if there's any feedback or suggestions.

thanks
-john


Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Prakash Kamliya <pkamliya@codeaurora.org>
Cc: Alistair Strachan <alistair.strachan@imgtec.com>
Cc: Todd Poynor <toddpoynor@google.com>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Android Kernel Team <kernel-team@android.com>



Alistair Strachan (1):
  staging: sync: Fix a race condition between release_obj and print_obj

Colin Cross (1):
  staging: ion: Fix overflow and list bugs in system heap

Greg Hackmann (1):
  staging: sw_sync: Add stubs for kernels without CONFIG_SW_SYNC

John Stultz (1):
  staging: ion: Fix build warning

Laura Abbott (1):
  staging: ion: Fix ION_IOC_FREE compat ioctl

Prakash Kamliya (1):
  staging: sync: Signal pt before sync_timeline object gets destroyed

Todd Poynor (1):
  staging: ashmem: Avoid deadlock between read and mmap calls

 drivers/staging/android/ashmem.c              | 45 ++++++++++++++++-----------
 drivers/staging/android/ion/compat_ion.c      | 26 +++++++++++++---
 drivers/staging/android/ion/ion_priv.h        |  1 +
 drivers/staging/android/ion/ion_system_heap.c |  6 +++-
 drivers/staging/android/sw_sync.h             | 17 ++++++++++
 drivers/staging/android/sync.c                | 14 ++++-----
 6 files changed, 78 insertions(+), 31 deletions(-)

-- 
1.8.3.2

