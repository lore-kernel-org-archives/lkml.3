Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaDVD7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:59:46 -0400
Received: from ozlabs.org ([103.22.144.67]:58581 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbaDVD7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 0/9] Avoid world-writable sysfs files.
Date: Tue, 22 Apr 2014 13:03:23 +0930
Message-Id: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds checking for world-writable sysfs files, after cleaning up
all the users.  This check has been in module sysfs params since 2006.

If you have a reason for being world-writable, please tell me now!

Rusty Russell (9):
  drivers/mtd/devices/docg3.c: avoid world-writable sysfs files.
  drivers/video/fbdev/sm501fb.c: avoid world-writable sysfs files.
  drivers/hid/hid-lg4ff.c: avoid world-writable sysfs files.
  drivers/scsi/pm8001/pm8001_ctl.c: avoid world-writable sysfs files.
  drivers/regulator/virtual: avoid world-writable sysfs files.
  drivers/staging/speakup/: avoid world-writable sysfs files.
  drivers/hid/hid-picolcd_fb: avoid world-writable sysfs files.
  samples/kobject/: avoid world-writable sysfs files.
  sysfs: disallow world-writable files.

 drivers/hid/hid-lg4ff.c                  |  2 +-
 drivers/hid/hid-picolcd_fb.c             |  2 +-
 drivers/mtd/devices/docg3.c              |  4 +--
 drivers/regulator/virtual.c              | 10 +++---
 drivers/scsi/pm8001/pm8001_ctl.c         |  2 +-
 drivers/staging/speakup/kobjects.c       | 60 ++++++++++++++++----------------
 drivers/staging/speakup/speakup_acntpc.c | 14 ++++----
 drivers/staging/speakup/speakup_acntsa.c | 14 ++++----
 drivers/staging/speakup/speakup_apollo.c | 16 ++++-----
 drivers/staging/speakup/speakup_audptr.c | 16 ++++-----
 drivers/staging/speakup/speakup_bns.c    | 14 ++++----
 drivers/staging/speakup/speakup_decext.c | 16 ++++-----
 drivers/staging/speakup/speakup_decpc.c  | 16 ++++-----
 drivers/staging/speakup/speakup_dectlk.c | 16 ++++-----
 drivers/staging/speakup/speakup_dtlk.c   | 20 +++++------
 drivers/staging/speakup/speakup_dummy.c  | 14 ++++----
 drivers/staging/speakup/speakup_keypc.c  | 10 +++---
 drivers/staging/speakup/speakup_ltlk.c   | 20 +++++------
 drivers/staging/speakup/speakup_soft.c   | 22 ++++++------
 drivers/staging/speakup/speakup_spkout.c | 16 ++++-----
 drivers/staging/speakup/speakup_txprt.c  | 14 ++++----
 drivers/video/fbdev/sm501fb.c            |  2 +-
 include/linux/kernel.h                   |  2 ++
 samples/kobject/kobject-example.c        |  7 ++--
 samples/kobject/kset-example.c           |  7 ++--
 25 files changed, 170 insertions(+), 166 deletions(-)

-- 
1.8.3.2

