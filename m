Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967196AbaFQWFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:05:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54769 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967009AbaFQVwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:11 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 077/212] bus: mvebu-mbus: allow several windows with the same target/attribute
Date: Tue, 17 Jun 2014 14:42:51 -0700
Message-Id: <1403041506-13646-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit b566e782be32145664d96ada3e389f17d32742e5 upstream.

Having multiple windows with the same target and attribute is actually
legal, and can be useful for PCIe windows, when PCIe BARs have a size
that isn't a power of two, and we therefore need to create several
MBus windows to cover the PCIe BAR for a given PCIe interface.

Fixes: fddddb52a6c4 ('bus: introduce an Marvell EBU MBus driver')
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397823593-1932-7-git-send-email-thomas.petazzoni@free-electrons.com
Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/bus/mvebu-mbus.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
index 2394e97..b4bd72b 100644
--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -222,12 +222,6 @@ static int mvebu_mbus_window_conflicts(struct mvebu_mbus_state *mbus,
 		 */
 		if ((u64)base < wend && end > wbase)
 			return 0;
-
-		/*
-		 * Check if target/attribute conflicts
-		 */
-		if (target == wtarget && attr == wattr)
-			return 0;
 	}
 
 	return 1;
-- 
1.9.1

