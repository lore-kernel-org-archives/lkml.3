Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab3HUTq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:46:59 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:58879 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3HUTq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:46:57 -0400
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl
Subject: [PATCH RFC 0/2] PM / Hibernate: sysfs resume 
Date: Wed, 21 Aug 2013 12:46:51 -0700
Message-Id: <1377114413-8521-1-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patchset related to hibernation resume: one enhancement to make the use
of an existing file more general and one documentation update.

Both patches are based on the 3.11-rc6 tag.  This was tested on a
Pandaboard with partial hibernation support, and compiled on x86.

Further testing is needed on other platforms.  Please let me know if
you're able to verify this on any other systems.

[PATCH RFC 1/2] PM / Hibernate: use name_to_dev_t to parse resume
  Use name_to_dev_t to parse the /sys/power/resume file making the
  syntax more flexible.  It supports the previous use syntax
  and additionally can support other formats such as
  /dev/devicenode and UUID= formats.

  By changing /sys/debug/resume to accept the same syntax as
  the resume=device parameter, we can parse the resume=device
  in the initrd init script and use the resume device directly
  from the kernel command line.

  kernel/power/hibernate.c |   14 +++++++++-----
  1 file changed, 9 insertions(+), 5 deletions(-)

[PATCH RFC 2/2] PM / Hibernate: add section for resume options
  This adds a small section to the swsusp.txt file to address the
  options for resuming.  This comments on the manual resume
  option which is used when resorting to an initrd or initramfs
  for resuming.  Resuming from late init is discussed later in
  the document, but it seemed appropriate to list them together.

  Documentation/power/swsusp.txt |   15 ++++++++++++++-
  1 file changed, 14 insertions(+), 1 deletion(-)

Thanks,

Sebastian
