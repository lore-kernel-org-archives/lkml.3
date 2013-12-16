Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3LPVcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:32:55 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43070 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3LPVcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:32:53 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [RFC][PATCH 0/3] ION fixups for staging-next
Date: Mon, 16 Dec 2013 13:32:41 -0800
Message-Id: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the ION patchset landed in staging-next, there have
been a few build issue reports, and this patchset tries
to address them.

I've marked these as RFC, as I'd really like to get acks
from Colin or someone else on the Android team on these
before merging them.

The first patch is the most trivial.

The second, I not sure if it is better to free the buffer and
continue looking for a smaller order, or if we should just free
the buffer and return NULL.

The last patch is the one I'm least confident of. We could simply
add a depends on RT_MUTEXES to the ION option, but since so few
drivers directly use rt_mutexes, and there's no documentation in
the code that I've noticed as to why the ion_heap uses an rt_mutex,
it probably is best to just convert it to a normal mutex. If this
is wrong, we can instead add the dependency and hopefully some
documentation.

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
 drivers/staging/android/ion/ion_heap.c        | 20 ++++++++++----------
 drivers/staging/android/ion/ion_system_heap.c |  5 +++++
 3 files changed, 16 insertions(+), 10 deletions(-)

-- 
1.8.3.2

