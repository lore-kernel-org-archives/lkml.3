Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3LSJnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:43:49 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40444 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3LSJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:43:46 -0500
Date: Thu, 19 Dec 2013 15:13:37 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        josh@joshtriplett.org
Subject: [PATCH 08/13] drivers: block: Mark function as static in
 drbd_actlog.c
Message-ID: <aaf95204c9af025e2ad4c00c0e9d6ed23bbe96ac.1387445396.git.rashika.kheria@gmail.com>
References: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f460591345e87defe53122cf056991c7f2eefa10.1387445396.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the function drbd_al_begin_io_prepare() as static in
drbd/drbd_actlog.c because it is not used outside this file.

This eliminates the following warnings in drbd/drbd_actlog.c:
drivers/block/drbd/drbd_actlog.c:277:6: warning: no previous prototype for ‘drbd_al_begin_io_prepare’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/block/drbd/drbd_actlog.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 28c73ca..7ba73c4 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -274,6 +274,7 @@ bool drbd_al_begin_io_fastpath(struct drbd_conf *mdev, struct drbd_interval *i)
 	return _al_get(mdev, first, true);
 }
 
+static
 bool drbd_al_begin_io_prepare(struct drbd_conf *mdev, struct drbd_interval *i)
 {
 	/* for bios crossing activity log extent boundaries,
-- 
1.7.9.5

