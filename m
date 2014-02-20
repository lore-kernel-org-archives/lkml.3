Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaBTUol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:44:41 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:59480 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaBTUoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:44:39 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/9] wireless/rt2x00: don't use PREPARE_WORK in rt2800usb.c
Date: Thu, 20 Feb 2014 15:44:23 -0500
Message-Id: <1392929071-16555-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392929071-16555-1-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
and a nasty surprise in terms of reentrancy guarantee as workqueue
considers work items to be different if they don't have the same work
function.

Update rt2800usb.c to use INIT_WORK() instead of PREPARE_WORK().  As
the work item isn't in active use during rt2800usb_probe_hw(), this
doesn't cause any behavior difference.

It would probably be best to route this with other related updates
through the workqueue tree.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index caddc1b..42a2e06 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -764,7 +764,7 @@ static int rt2800usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Overwrite TX done handler
 	 */
-	PREPARE_WORK(&rt2x00dev->txdone_work, rt2800usb_work_txdone);
+	INIT_WORK(&rt2x00dev->txdone_work, rt2800usb_work_txdone);
 
 	return 0;
 }
-- 
1.8.5.3

