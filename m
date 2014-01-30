Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaA3VMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 16:12:16 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34631 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbaA3VMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 16:12:14 -0500
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org
Subject: 
Date: Thu, 30 Jan 2014 13:11:56 -0800
Message-Id: <1391116318-17253-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset related to hibernation resume:
  - enhancement to make the use of an existing resume file more general
  - add kstrimdup function which trims and duplicates a string

  Both patches are based on the 3.13 tag.  This was tested on a
  Beaglebone black with partial hibernation support, and compiled for
  x86_64.

[PATCH v5 1/2] mm: add kstrimdup function
  include/linux/string.h |    1 +
  mm/util.c              |   30 ++++++++++++++++++++++++++++++
  2 files changed, 31 insertions(+)

  Adds the kstrimdup function to duplicate and trim whitespace
  from a string.  This is useful for working with user input to
  sysfs.

[PATCH v5 2/2] PM / Hibernate: use name_to_dev_t to parse resume
  kernel/power/hibernate.c |   33
  +++++++++++++++++----------------
  1 file changed, 17 insertions(+), 16 deletions(-)

  Use name_to_dev_t to parse the /sys/power/resume file making the
  syntax more flexible.  It supports the previous use syntax
  and additionally can support other formats such as
  /dev/devicenode and UUID= formats.

  By changing /sys/debug/resume to accept the same syntax as
  the resume=device parameter, we can parse the resume=device
  in the initrd init script and use the resume device directly
  from the kernel command line.

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


