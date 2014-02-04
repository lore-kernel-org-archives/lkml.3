Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbaBDUn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:43:56 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39898 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932588AbaBDUnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:43:51 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: [PATCH v7 0/3] hibernation related patches
Date: Tue,  4 Feb 2014 12:43:48 -0800
Message-Id: <1391546631-7715-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset related to hibernation resume:
  - enhancement to make the use of an existing resume file more general
  - add kstrdup_trimnl function which duplicates and trims a single
    trailing newline off of a string
  - cleanup checkpatch warnings in hibernate.c file

  All patches are based on the 3.13 tag.  This was tested on a
  Beaglebone black with partial hibernation support, and compiled for
  x86_64.

[PATCH v7 1/3] mm: add kstrdup_trimnl function
  include/linux/string.h |    1 +
  mm/util.c              |   29 +++++++++++++++++++++++++++++
  2 files changed, 30 insertions(+)

  Adds the kstrdup_trimnl function to duplicate and trim
  at most one trailing newline from a string.
  This is useful for working with user input to sysfs.

[PATCH v7 2/3] trivial: PM / Hibernate: clean up checkpatch in
  kernel/power/hibernate.c |   62 ++++++++++++++++++++++++----------------------
  1 file changed, 32 insertions(+), 30 deletions(-)

  Cleanup checkpatch warnings in kernel/power/hibernate.c

[PATCH v7 3/3] PM / Hibernate: use name_to_dev_t to parse resume
  kernel/power/hibernate.c |   33 +++++++++++++++++----------------
  1 file changed, 17 insertions(+), 16 deletions(-)

  Use name_to_dev_t to parse the /sys/power/resume file making the
  syntax more flexible.  It supports the previous use syntax
  and additionally can support other formats such as
  /dev/devicenode and UUID= formats.

  By changing /sys/debug/resume to accept the same syntax as
  the resume=device parameter, we can parse the resume=device
  in the initrd init script and use the resume device directly
  from the kernel command line.


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
