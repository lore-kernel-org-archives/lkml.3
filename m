Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3IRXaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 19:30:03 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51717 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab3IRXaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 19:30:00 -0400
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH v3 RFT 0/2] PM / Hibernate: sysfs resume 
Date: Wed, 18 Sep 2013 16:29:00 -0700
Message-Id: <1379546942-22344-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset related to hibernation resume: one enhancement to make the use
of an existing resume file more general and one enhances name_to_dev_t
to ignore the trailing newlines coming from userspace.

Both patches are based on the 3.11 tag.  This was tested on a
Pandaboard with partial hibernation support, and compiled for x86.

Further testing is needed on other platforms.  Please let me know if
you're able to verify this on any other systems.

[PATCH 1/2] init/do_mounts.c: ignore final \n in name_to_dev_t
  init/do_mounts.c |   23 ++++++++++++++++++-----
  1 file changed, 18 insertions(+), 5 deletions(-)

  Changes name_to_dev_t to handle a trailing newline in the
  input buffer, which will allow name_to_dev_t to be used
  directly with user buffers without requiring a copy.
  Also adds a const to the name parameter which reflects
  how name_to_dev_t is treating the input buffer currently.
  This also allows direct use of user buffers
  (from resume_store for example).

[PATCH 2/2] PM / Hibernate: use name_to_dev_t to parse resume
  kernel/power/hibernate.c |   15 ++++-----------
  1 file changed, 4 insertions(+), 11 deletions(-)

  Use name_to_dev_t to parse the /sys/power/resume file making the
  syntax more flexible.  It supports the previous use syntax
  and additionally can support other formats such as
  /dev/devicenode and UUID= formats.

  By changing /sys/debug/resume to accept the same syntax as
  the resume=device parameter, we can parse the resume=device
  in the initrd init script and use the resume device directly
  from the kernel command line.

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

