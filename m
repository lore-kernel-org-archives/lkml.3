Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3C0Crn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 22:47:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63184 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab3C0Crl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 22:47:41 -0400
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: mchehab@redhat.com
Cc: andrew.smirnov@gmail.com, hverkuil@xs4all.nl, sameo@linux.intel.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v8 0/9] Driver for Si476x series of chips
Date: Tue, 26 Mar 2013 19:47:17 -0700
Message-Id: <1364352446-28572-1-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for Si476x series of chips

This is a eight version of the patchset originaly posted here:
https://lkml.org/lkml/2012/9/13/590

Second version of the patch was posted here:
https://lkml.org/lkml/2012/10/5/598

Third version of the patch was posted here:
https://lkml.org/lkml/2012/10/23/510

Fourth version of the patch was posted here:
https://lkml.org/lkml/2013/2/18/572

Fifth version of the patch was posted here:
https://lkml.org/lkml/2013/2/26/45

Sixth version of the patch was posted here:
https://lkml.org/lkml/2013/2/26/257

Seventh version of the patch was posted here:
https://lkml.org/lkml/2013/2/27/22


To save everyone's time I'll repost the original description of it:

This patchset contains a driver for a Silicon Laboratories 476x series
of radio tuners. The driver itself is implemented as an MFD devices
comprised of three parts: 
 1. Core device that provides all the other devices with basic
functionality and locking scheme.
 2. Radio device that translates between V4L2 subsystem requests into
Core device commands.
 3. Codec device that does similar to the earlier described task, but
for ALSA SoC subsystem.

v8 of this driver has following changes:
   - checkpatch.pl fixes

Pleas note that patches are not completely warning free, as far as
checkpatch.pl is concerned, because I skipped all the places where
80-character compliance can be acheived only by means of weird
indentation.

Andrey Smirnov (9):
  mfd: Add commands abstraction layer for SI476X MFD
  mfd: Add the main bulk of core driver for SI476x code
  mfd: Add chip properties handling code for SI476X MFD
  mfd: Add header files and Kbuild plumbing for SI476x MFD core
  v4l2: Fix the type of V4L2_CID_TUNE_PREEMPHASIS in the documentation
  v4l2: Add standard controls for FM receivers
  v4l2: Add documentation for the FM RX controls
  v4l2: Add private controls base for SI476X
  v4l2: Add a V4L2 driver for SI476X MFD

 Documentation/DocBook/media/v4l/compat.xml         |    3 +
 Documentation/DocBook/media/v4l/controls.xml       |   74 +-
 .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       |    9 +
 Documentation/video4linux/si476x.txt               |  187 +++
 drivers/media/radio/Kconfig                        |   17 +
 drivers/media/radio/Makefile                       |    1 +
 drivers/media/radio/radio-si476x.c                 | 1599 ++++++++++++++++++++
 drivers/media/v4l2-core/v4l2-ctrls.c               |   14 +-
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    4 +
 drivers/mfd/si476x-cmd.c                           | 1554 +++++++++++++++++++
 drivers/mfd/si476x-i2c.c                           |  886 +++++++++++
 drivers/mfd/si476x-prop.c                          |  242 +++
 include/linux/mfd/si476x-core.h                    |  525 +++++++
 include/media/si476x.h                             |  426 ++++++
 include/uapi/linux/v4l2-controls.h                 |   17 +
 16 files changed, 5566 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/video4linux/si476x.txt
 create mode 100644 drivers/media/radio/radio-si476x.c
 create mode 100644 drivers/mfd/si476x-cmd.c
 create mode 100644 drivers/mfd/si476x-i2c.c
 create mode 100644 drivers/mfd/si476x-prop.c
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/media/si476x.h

-- 
1.7.10.4

