Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3JRUoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 16:44:09 -0400
Received: from ppsw-42.csi.cam.ac.uk ([131.111.8.142]:57466 "EHLO
	ppsw-42.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3JRUoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 16:44:08 -0400
X-Greylist: delayed 1231 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2013 16:44:07 EDT
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Fri, 18 Oct 2013 21:23:35 +0100 (BST)
From: Ben Harris <bjh21@cam.ac.uk>
To: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
cc: 726655@bugs.debian.org
Subject: [PATCH] floppy: Correct documentation of driver options when used
 as a module.
Message-ID: <alpine.DEB.2.02.1310182117100.1531@puff.ds.cam.ac.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Harris <bjh21@cam.ac.uk>

The options have to be passed space-separated and prefixed by "floppy=", 
rather than separately and unprefixed.

This fixes <http://bugs.debian.org/726655>.

Signed-off-by: Ben Harris <bjh21@cam.ac.uk>
---
This patch is against Linux 3.12-rc5.

--- linux-3.12-rc5/Documentation/blockdev/floppy.txt.orig       2013-10-13 23:41:28.000000000 +0100
+++ linux-3.12-rc5/Documentation/blockdev/floppy.txt    2013-10-18 21:03:27.000000000 +0100
@@ -39,15 +39,15 @@ Module configuration options
  ============================

   If you use the floppy driver as a module, use the following syntax:
-modprobe floppy <options>
+modprobe floppy floppy="<options>"

  Example:
- modprobe floppy omnibook messages
+ modprobe floppy floppy="omnibook messages"

   If you need certain options enabled every time you load the floppy driver,
  you can put:

- options floppy omnibook messages
+ options floppy floppy="omnibook messages"

  in a configuration file in /etc/modprobe.d/.

-- 
Ben Harris, University of Cambridge Computing Service.
