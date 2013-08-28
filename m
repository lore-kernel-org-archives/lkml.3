Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3H1BO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:14:27 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:43018 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab3H1BOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:14:19 -0400
From: Sebastian Capella <sebastian.capella@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@lists.infradead.org, linux-pm@vger.kernel.org,
        linaro-dev@lists.linaro.org
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        Rob Landley <rob@landley.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH v2 RFT 2/2] PM / Hibernate: add section for resume options
Date: Tue, 27 Aug 2013 18:13:57 -0700
Message-Id: <1377652437-2379-3-git-send-email-sebastian.capella@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377652437-2379-1-git-send-email-sebastian.capella@linaro.org>
References: <1377652437-2379-1-git-send-email-sebastian.capella@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the existing documentation to explicitly list the options for
resuming a hibernation image, including the manual resume option which
can be used from the initrd or initramfs and the kernel init resume.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Rob Landley <rob@landley.net>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
 Documentation/power/swsusp.txt |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
index 0b4b63e..079160e 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.txt
@@ -50,6 +50,19 @@ echo N > /sys/power/image_size
 
 before suspend (it is limited to 500 MB by default).
 
+. The resume process checks for the presence of the resume device,
+if found, it then checks the contents for the hibernation image signature.
+If both are found, it resumes the hibernation image.
+
+. The resume process may be triggered in two ways:
+  1) During lateinit:  If resume=/dev/your_swap_partition is specified on
+     the kernel command line, lateinit runs the resume process.  If the
+     resume device has not been probed yet, the resume process fails and
+     bootup continues.
+  2) Manually from an initrd or initramfs:  May be run from
+     the init script by using the /sys/power/resume file.  It is vital
+     that this be done prior to remounting any filesystems (even as
+     read-only) otherwise data may be corrupted.
 
 Article about goals and implementation of Software Suspend for Linux
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -326,7 +339,7 @@ Q: How can distributions ship a swsusp-supporting kernel with modular
 disk drivers (especially SATA)?
 
 A: Well, it can be done, load the drivers, then do echo into
-/sys/power/disk/resume file from initrd. Be sure not to mount
+/sys/power/resume file from initrd. Be sure not to mount
 anything, not even read-only mount, or you are going to lose your
 data.
 
-- 
1.7.9.5

