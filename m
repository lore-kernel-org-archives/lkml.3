Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab3LVNhj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 08:37:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51085 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3LVNhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 08:37:38 -0500
X-Greylist: delayed 648 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Dec 2013 08:37:37 EST
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 22 Dec 2013 14:26:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [git pull] FireWire fixlet
Message-ID: <20131222142635.0589fe40@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from the tag "firewire-fix" at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git firewire-fix

to receive a one-liner fix/ revert.  This reenables WRITE SAME over SBP-2
like in v3.8...v3.12 (or v3.8-rc1...v3.13-rc2 to be overly precise).
Buggy targets which could malfunction when being subjected to this command
are already sufficiently protected by a scsi_level check in sd + SCSI core.

Stefan Richter (1):
      firewire: sbp2: bring back WRITE SAME support

 drivers/firewire/sbp2.c | 1 -
 1 file changed, 1 deletion(-)

>From ce027ed98fd176710fb14be9d6015697b62436f0 Mon Sep 17 00:00:00 2001
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Sun, 15 Dec 2013 16:18:01 +0100
Subject: [PATCH] firewire: sbp2: bring back WRITE SAME support

Commit 54b2b50c20a6 "[SCSI] Disable WRITE SAME for RAID and virtual
host adapter drivers" disabled WRITE SAME support for all SBP-2 attached
targets.  But as described in the changelog of commit b0ea5f19d3d8
"firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED OPERATION CODES",
it is not required to blacklist WRITE SAME.

Bring the feature back by reverting the sbp2.c hunk of commit 54b2b50c20a6.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@kernel.org
---
 drivers/firewire/sbp2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index b0bb056458a3..281029daf98c 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1623,7 +1623,6 @@ static struct scsi_host_template scsi_driver_template = {
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
-	.no_write_same		= 1,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");
-- 
Stefan Richter
-=====-===-= ==-- =-==-
http://arcgraph.de/sr/
