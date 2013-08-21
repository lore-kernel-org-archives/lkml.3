Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3HUUJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 16:09:32 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47949 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3HUUJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 16:09:30 -0400
From: sebastian.capella@linaro.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Cc: rob@landley.net
Cc: len.brown@intel.com
Cc: pavel@ucw.cz
Cc: rjw@sisk.pl
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: rob@landley.net
Cc: rob@landley.net
To: linux-doc@vger.kernel.org
Message-ID: <20130821200927.9309.26821@capellas-linux>
User-Agent: alot/0.3.4
Date: Wed, 21 Aug 2013 13:09:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Capella <sebastian.capella@linaro.org>
Subject: [PATCH RFC 2/2] PM / Hibernate: add section for resume options

Expand the existing documentation to explicitly list the options for
resuming a hibernation image, including the manual resume option which
can be used from the initrd or initramfs and the kernel init resume.

Signed-off-by: Sebastian Capella <sebastian.capella@linaro.org>
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
