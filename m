Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3D2VTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:19:35 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:15184 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab3D2VTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:19:23 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>, Karel Zak <kzak@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5/5] partitions/Kconfig: add the AIX_PARTITION entry
Date: Mon, 29 Apr 2013 23:18:33 +0200
Message-Id: <1367270313-18871-6-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1367270313-18871-1-git-send-email-phdm@macqel.be>
References: <1367270313-18871-1-git-send-email-phdm@macqel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the final patch enabling a user to select AIX lvm partitions
detection.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Cc: Karel Zak <kzak@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 block/partitions/Kconfig |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/block/partitions/Kconfig b/block/partitions/Kconfig
index 75a54e1..4cebb2f 100644
--- a/block/partitions/Kconfig
+++ b/block/partitions/Kconfig
@@ -68,6 +68,17 @@ config ACORN_PARTITION_RISCIX
 	  of machines called RISCiX.  If you say 'Y' here, Linux will be able
 	  to read disks partitioned under RISCiX.
 
+config AIX_PARTITION
+	bool "AIX basic partition table support" if PARTITION_ADVANCED
+	help
+	  Say Y here if you would like to be able to read the hard disk
+	  partition table format used by IBM or Motorola PowerPC machines
+	  running AIX.  AIX actually uses a Logical Volume Manager, where
+	  "logical volumes" can be spread across one or multiple disks,
+	  but this driver works only for the simple case of partitions which
+	  are contiguous.
+	  Otherwise, say N.
+
 config OSF_PARTITION
 	bool "Alpha OSF partition support" if PARTITION_ADVANCED
 	default y if ALPHA
-- 
1.7.1

