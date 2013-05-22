Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3EVKNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 06:13:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35555 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755001Ab3EVKNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 06:13:10 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v4 0/6] Android Binder IPC Fixes
Date: Wed, 22 May 2013 11:12:55 +0100
Message-Id: <1369217581-16285-1-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This set of patches will clean-up and fix some of the issues that arise
with the current binder interface when moving to a 64bit kernel. All these
changes will not affect the existing 32bit Android interface and are meant
to stand as the base for the 64bit binder compat layer(kernel or userpsace).

The patch set has been successfully tested with a 64bit Linux userspace and
64bit binder unit-tests.

This patch set has been successfully tested on 32bit platforms(ARMv7 VExpress)
and 64bit platforms(ARMv8 RTSM) running a 32bit Android userspace and an in
kernel binder compat layer.

Changes for v4:
1: 5/6: Fix the offset buffer alignment such that it will work for cases where
buffer start + buffer size are not aligned to (void *)

Changes for v3:
1:  Dropped the patch that was replacing uint32_t types with unsigned int
2:  Dropped the patch fixing the IOCTL types(since it has been added to Greg's
    staging tree)
3:  Split one patch into two: 'modify binder_write_read' and '64bit changes'
4:  Modified BINDER_SET_MAX_THREADS ioctl definition accordint to Arve's review
5:  Modified the binder command IOCTL declarations according to Arve's review

Changes for v2:
1: 1/7: Modified the commit message according to Greg's feedback;
2: 3/7: Merged with the patch fixing the printk format specifiers.

Serban Constantinescu (6):
  staging: android: binder: modify struct binder_write_read to use
    size_t
  staging: android: binder: fix binder interface for 64bit compat layer
  staging: android: binder: fix BINDER_SET_MAX_THREADS declaration
  staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
  staging: android: binder: fix alignment issues
  staging: android: binder: replace types with portable ones

 drivers/staging/android/binder.c |   46 +++++++++++++++++++-------------------
 drivers/staging/android/binder.h |   46 +++++++++++++++++++-------------------
 2 files changed, 46 insertions(+), 46 deletions(-)

-- 
1.7.9.5

