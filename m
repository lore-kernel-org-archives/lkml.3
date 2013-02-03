Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab3BCPAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:00:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34629 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab3BCO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:27 -0500
Message-Id: <20130203144654.995711811@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:48 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [ 124/128] drbd: add missing part_round_stats to _drbd_start_io_acct
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 72585d2428fa3a0daab02ebad1f41e5ef517dbaa upstream.

Without this, iostat frequently sees bogus svctime and >= 100% "utilization".

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/drbd/drbd_req.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -37,6 +37,7 @@ static void _drbd_start_io_acct(struct d
 	const int rw = bio_data_dir(bio);
 	int cpu;
 	cpu = part_stat_lock();
+	part_round_stats(cpu, &mdev->vdisk->part0);
 	part_stat_inc(cpu, &mdev->vdisk->part0, ios[rw]);
 	part_stat_add(cpu, &mdev->vdisk->part0, sectors[rw], bio_sectors(bio));
 	part_inc_in_flight(&mdev->vdisk->part0, rw);


