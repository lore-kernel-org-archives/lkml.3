Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3GDJyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:54:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49463 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659Ab3GDJyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:54:41 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH v6 0/6] Android Binder IPC Fixes
Date: Thu,  4 Jul 2013 10:54:42 +0100
Message-Id: <1372931688-18553-1-git-send-email-serban.constantinescu@arm.com>
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

Changes for v6:
1 6/6: Modified struct binder_pri_desc according to Arve's feedback - member
       "desc" defined as an __u32 type.

Changes for v5:
1 6/6: Moved patch to the end of the series; changed handle to use __u32 type
2 4/6: Removed some of the alignment/buffer changes introduced in previous
       versions of the patch.

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
  staging: android: binder: fix BINDER_SET_MAX_THREADS declaration
  staging: android: binder: fix BC_FREE_BUFFER ioctl declaration
  staging: android: binder: fix alignment issues
  staging: android: binder: replace types with portable ones
  staging: android: binder: fix binder interface for 64bit compat layer

 drivers/staging/android/binder.c |   32 ++++++++++++-------------
 drivers/staging/android/binder.h |   48 +++++++++++++++++++-------------------
 2 files changed, 40 insertions(+), 40 deletions(-)

-- 
1.7.9.5

