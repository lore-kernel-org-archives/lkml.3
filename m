Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524AbaFIJCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:02:33 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58548 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932102AbaFIIv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 107/146] bus: mvebu-mbus: allow several windows with the same target/attribute
Date: Mon,  9 Jun 2014 10:50:42 +0200
Message-Id: <83716f8c73ed542c125a3554fae7507eb00a10fa.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bus/mvebu-mbus.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
index 2394e9753ef5..b4bd72b6fdc8 100644
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
1.9.3

