Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751072Ab3LQFIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:08:00 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48529 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3LQFH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:07:58 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 0/3] ION fixups for staging-next (v2)
Date: Mon, 16 Dec 2013 21:07:50 -0800
Message-Id: <1387256873-21350-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the ION patchset landed in staging-next, there have
been a few build issue reports, and this patchset tries
to address them.

Dropped the RFC, as I think the first two are good to go, but
I'd still like to get acks from Colin or someone else on the
Android team on all of these before merging these, as some bits
were a bit more complex then I'd like.

Changes in v2:
o Fixed up style issue Greg caught
o Reworked second patch to simplify error path and just return
  null if kmalloc fails
o Per Colin's suggestion, reworked third patch to use spinlocks.
  This ended up being a bit more complicated to get right, and
  I'd appreciate very close review, but it seems to be working
  ok in testing on both ARM and x86_64 w/o triggering any lockdep
  or other warnings.


I'd appreciate any thoughts or comments!

thanks
-john

Cc: Colin Cross <ccross@android.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Greg KH <gregkh@linuxfoundation.org>


John Stultz (3):
  staging: ion: Add HAVE_MEMBLOCK config dependency
  staging: ion: Fix possible null pointer dereference
  staging: ion: Avoid using rt_mutexes directly.

 drivers/staging/android/ion/Kconfig           |  1 +
 drivers/staging/android/ion/ion_heap.c        | 31 ++++++++++++++++-----------
 drivers/staging/android/ion/ion_priv.h        |  2 +-
 drivers/staging/android/ion/ion_system_heap.c |  7 +++++-
 4 files changed, 27 insertions(+), 14 deletions(-)

-- 
1.8.3.2

