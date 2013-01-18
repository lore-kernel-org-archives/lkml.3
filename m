Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3ARTU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:20:56 -0500
Received: from mail.ipax.at ([93.189.24.40]:40043 "EHLO mail.ipax.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248Ab3ARTUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:20:54 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2013 14:20:54 EST
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2013 20:12:43 +0100
From: Raoul Bhatia <raoul@bhatia.at>
To: <stable@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <ben@decadent.org.uk>
Subject: [PATCH 3.2.y] drbd: add missing =?UTF-8?Q?part=5Fround=5Fstats=20?=
 =?UTF-8?Q?to=20=5Fdrbd=5Fstart=5Fio=5Facct?=
Message-ID: <af68fe0b3f591430c834ecd6bd9f90f7@bhatia.at>
User-Agent: Roundcube Webmail/0.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 72585d2428fa3a0daab02ebad1f41e5ef517dbaa upstream

Please include upstream patch 72585d2428fa3a0daab02ebad1f41e5ef517dbaa 
into 3.2.y.
Patch from git below.

Please also see the discussion at
http://lists.linbit.com/pipermail/drbd-user/2012-January/017622.html

and the upstream patches at
https://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=72585d2428fa3a0daab02ebad1f41e5ef517dbaa
http://git.drbd.org/gitweb.cgi?p=drbd-8.3.git;a=commitdiff;h=80cb2183911626747d3f7546fe3cb3c1abe6ba41

Thanks,
Raoul

 From 72585d2428fa3a0daab02ebad1f41e5ef517dbaa Mon Sep 17 00:00:00 2001
 From: Philipp Reisner <philipp.reisner@linbit.com>
Date: Thu, 23 Feb 2012 12:56:26 +0100
Subject: [PATCH] drbd: add missing part_round_stats to 
_drbd_start_io_acct

Without this, iostat frequently sees bogus svctime and >= 100% 
"utilization".

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
  drivers/block/drbd/drbd_req.c |    1 +
  1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c 
b/drivers/block/drbd/drbd_req.c
index 4737ad1..bfd14bc 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -39,6 +39,7 @@ static void _drbd_start_io_acct(struct drbd_conf 
*mdev, struct drbd_request *req
  	const int rw = bio_data_dir(bio);
  	int cpu;
  	cpu = part_stat_lock();
+	part_round_stats(cpu, &mdev->vdisk->part0);
  	part_stat_inc(cpu, &mdev->vdisk->part0, ios[rw]);
  	part_stat_add(cpu, &mdev->vdisk->part0, sectors[rw], 
bio_sectors(bio));
  	(void) cpu; /* The macro invocations above want the cpu argument, I 
do not like
-- 
1.7.6.5

-- 
DI (FH) Raoul Bhatia M.Sc.     |   E-Mail.  raoul@bhatia.at
Software Development and       |   Web.     http://www.ipax.at
System Administration          |   Tel.     +43 699 10132530
