Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaBNWxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 17:53:00 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37462 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaBNWw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 17:52:59 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH v9 0/1] hibernation related patches
Date: Fri, 14 Feb 2014 14:52:55 -0800
Message-Id: <1392418376-30060-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset related to hibernation resume:
  - enhancement to make the use of an existing resume file more general

  Patch is based on the 3.13 tag.  This was tested on a Beaglebone black
  with partial hibernation support, also compiled for x86_64.

[PATCH v9 1/1] PM / Hibernate: use name_to_dev_t to parse resume
  kernel/power/hibernate.c |   22 ++++++++++++----------
  1 file changed, 12 insertions(+), 10 deletions(-)

  Use name_to_dev_t to parse the /sys/power/resume file making the
  syntax more flexible.  It supports the previous use syntax
  and additionally can support other formats such as
  /dev/devicenode and UUID= formats.

  By changing /sys/debug/resume to accept the same syntax as
  the resume=device parameter, we can parse the resume=device
  in the initrd init script and use the resume device directly
  from the kernel command line.

Changes in v9:
--------------
* Dropped util changes based on feedback
* Reverted to handling newlines in resume_store

Changes in v8:
--------------
* Dropped cleanup checkpatch warnings in hibernate.c file
* Review comments for more compact checking in hibernate.c

Changes in v7:
--------------
* Switch to trim only one trailing newline if present using kstrdup_trimnl
* remove kstrimdup patch
* add kstrdup_trimnl patch
* Add clean up patch for kernel/power/hibernate.c checkpatch warnings

Changes in v6:
--------------
* Revert tricky / confusing while loop indexing

Changes in v5:
--------------
* Change kstrimdup to minimize allocated memory.  Now allocates only
  the memory needed for the string instead of using strim.

Changes in v4:
--------------
* Dropped name_to_dev_t rework in favor of adding kstrimdup
* adjusted resume_store

Changes in v3:
--------------
* Dropped documentation patch as it went in through trivial
* Added patch for name_to_dev_t to support directly parsing userspace
  buffer

Changes in v2:
--------------
* Added check for null return of kstrndup in hibernate.c


Thanks,

Sebastian
