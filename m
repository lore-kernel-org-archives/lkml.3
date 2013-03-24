Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3CXQbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 12:31:51 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54650 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054Ab3CXQbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 12:31:50 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Mar 2013 17:31:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: sbp2: replace BUG_ON by WARN_ON
Message-ID: <20130324173138.0bf9a47f@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to crash and burn if S/G element sizes cannot be set to our
liking; just leave a message in the log.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1144,8 +1144,8 @@ static int sbp2_probe(struct device *dev
 		return -ENODEV;
 
 	if (dma_get_max_seg_size(device->card->device) > SBP2_MAX_SEG_SIZE)
-		BUG_ON(dma_set_max_seg_size(device->card->device,
-					    SBP2_MAX_SEG_SIZE));
+		WARN_ON(dma_set_max_seg_size(device->card->device,
+					     SBP2_MAX_SEG_SIZE));
 
 	shost = scsi_host_alloc(&scsi_driver_template, sizeof(*tgt));
 	if (shost == NULL)


-- 
Stefan Richter
-=====-===-= --== ==---
http://arcgraph.de/sr/
