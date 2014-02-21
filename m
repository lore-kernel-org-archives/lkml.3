Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaBUUnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:43:45 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33967 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaBUUno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:43:44 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Greg KH <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: [PATCH 0/3] Binder ABI updates for 64bit systems for staging-next
Date: Fri, 21 Feb 2014 12:43:31 -0800
Message-Id: <1393015414-12499-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanted to re-submit to staging-next two changes from the AOSP
common.git android-3.10 branch, which provide ABI fixes and
introduce a new ABI and protocol version for binder, along
with compatibility support for existing systems.

This new ABI allows for both 32bit and 64bit applications
to co-exist, which wasn't previously possible due to word
size assumptions in the binder protocol.

Also included is a minor tweak from me to make the Kconfig
compatibility entry a bit more clear.

The changes have been updated to improve their commit message
since the last time they were submitted. Thanks to Arve for the
extra context and Serban for help with the wording.

thanks
-john

Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: Android Kernel Team <kernel-team@android.com>


Arve Hjønnevåg (1):
  staging: binder: Support concurrent 32 bit and 64 bit processes.

John Stultz (1):
  staging: binder: Improve Kconfig entry for ANDROID_BINDER_IPC_32BIT

Serban Constantinescu (1):
  staging: binder: Fix ABI for 64bit Android

 drivers/staging/android/Kconfig        |  13 ++
 drivers/staging/android/binder.c       | 268 ++++++++++++++++++---------------
 drivers/staging/android/binder.h       |   4 +
 drivers/staging/android/binder_trace.h |  14 +-
 drivers/staging/android/uapi/binder.h  |  77 ++++++----
 5 files changed, 224 insertions(+), 152 deletions(-)

-- 
1.8.3.2

