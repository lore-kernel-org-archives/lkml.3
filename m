Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3EQNIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:08:52 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40697 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab3EQNIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:08:51 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH v2] block: remove refs to XD disks from documentation
Date: Fri, 17 May 2013 15:08:41 +0200
Message-Id: <1368796121-4593-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d1a6f4f19728d6e90480e53601a90fc9f6a348ad
"block: delete super ancient PC-XT driver for 1980's hardware"
deleted the XD disk driver, but there are still a few
references to it in the documentation directory. Delete
the remnants and thus also free up the major block device
13 for reuse.

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Put a smallish notice on the block device entry in
  Documentation/devices.txt instead of just blanking it out,
  as suggested by Paul Gortmaker.
---
 Documentation/devices.txt             | 8 ++------
 Documentation/kernel-parameters.txt   | 3 ---
 Documentation/m68k/kernel-options.txt | 2 --
 3 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/Documentation/devices.txt b/Documentation/devices.txt
index 08f01e7..b901591 100644
--- a/Documentation/devices.txt
+++ b/Documentation/devices.txt
@@ -498,12 +498,8 @@ Your cooperation is appreciated.
 
 		Each device type has 5 bits (32 minors).
 
- 13 block	8-bit MFM/RLL/IDE controller
-		  0 = /dev/xda		First XT disk whole disk
-		 64 = /dev/xdb		Second XT disk whole disk
-
-		Partitions are handled in the same way as IDE disks
-		(see major number 3).
+ 13 block	Previously used for the XT disk (/dev/xdN)
+		Deleted in kernel v3.9.
 
  14 char	Open Sound System (OSS)
 		  0 = /dev/mixer	Mixer control
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c3bfacb..5469dbf 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3330,9 +3330,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			plus one apbt timer for broadcast timer.
 			x86_mrst_timer=apbt_only | lapic_and_apbt
 
-	xd=		[HW,XT] Original XT pre-IDE (RLL encoded) disks.
-	xd_geo=		See header of drivers/block/xd.c.
-
 	xen_emul_unplug=		[HW,X86,XEN]
 			Unplug Xen emulated devices
 			Format: [unplug0,][unplug1]
diff --git a/Documentation/m68k/kernel-options.txt b/Documentation/m68k/kernel-options.txt
index 97d45f2..eaf32a1 100644
--- a/Documentation/m68k/kernel-options.txt
+++ b/Documentation/m68k/kernel-options.txt
@@ -80,8 +80,6 @@ Valid names are:
   /dev/sdd: -> 0x0830 (forth SCSI disk)
   /dev/sde: -> 0x0840 (fifth SCSI disk)
   /dev/fd : -> 0x0200 (floppy disk)
-  /dev/xda: -> 0x0c00 (first XT disk, unused in Linux/m68k)
-  /dev/xdb: -> 0x0c40 (second XT disk, unused in Linux/m68k)
 
   The name must be followed by a decimal number, that stands for the
 partition number. Internally, the value of the number is just
-- 
1.8.1.4

