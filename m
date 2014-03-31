Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaCaIHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:07:12 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54946 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaCaIGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:06:33 -0400
From: Michael Schmitz <schmitzmic@gmail.com>
To: linux-m68k@vger.kernel.org
Cc: geert@linux-m68k.org, debian-68k@lists.debian.org,
        Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/4] m68k/atari - ataflop: use correct virt/phys translation for DMA buffer
Date: Mon, 31 Mar 2014 21:06:07 +1300
Message-Id: <1396253168-25601-4-git-send-email-schmitz@debian.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1396253168-25601-1-git-send-email-schmitz@debian.org>
References: <1396253168-25601-1-git-send-email-schmitz@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the kernel running from FastRAM instead of ST-RAM, none of ST-RAM is
mapped by mem_init, and DMA-addressable buffer must be mapped by ioremap.

Use platform specific virt/phys translation helpers for this case.

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Cc: linux-kernel@vger.kernel.org
---
 drivers/block/ataflop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 0e30c6e..f54655a 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1952,7 +1952,7 @@ static int __init atari_floppy_init (void)
 		goto Enomem;
 	}
 	TrackBuffer = DMABuffer + 512;
-	PhysDMABuffer = virt_to_phys(DMABuffer);
+	PhysDMABuffer = atari_stram_to_phys(DMABuffer);
 	PhysTrackBuffer = virt_to_phys(TrackBuffer);
 	BufferDrive = BufferSide = BufferTrack = -1;
 
-- 
1.7.0.4

