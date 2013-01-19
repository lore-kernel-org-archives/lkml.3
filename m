Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3ASBYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:24:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:57255 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756737Ab3ASBWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:22:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Raoul Bhatia <raoul@bhatia.at>
Subject: [ 10/16] drbd: add missing part_round_stats to _drbd_start_io_acct
Date: Fri, 18 Jan 2013 17:21:48 -0800
Message-Id: <20130119012139.891644530@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119012138.680057206@linuxfoundation.org>
References: <20130119012138.680057206@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 72585d2428fa3a0daab02ebad1f41e5ef517dbaa upstream.

Without this, iostat frequently sees bogus svctime and >= 100% "utilization".

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Raoul Bhatia <raoul@bhatia.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


