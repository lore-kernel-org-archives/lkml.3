Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaBINCD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:02:03 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44597 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaBINCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:02:01 -0500
Date: Sun, 9 Feb 2014 18:31:56 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@tonian.com>,
        osd-dev@open-osd.org, josh@joshtriplett.org
Subject: [PATCH 05/21] fs: Mark function as static in exofs/super.c
Message-ID: <008a7e048e6eee2d773e092660183f21d52e4874.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in exofs/super.c because it is not used outside
this file.

This also eliminates the following warning in exofs/super.c:
fs/exofs/super.c:546:5: warning: no previous prototype for ‘__alloc_dev_table’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/exofs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 9d97633..57f59a2 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -543,8 +543,8 @@ static int exofs_devs_2_odi(struct exofs_dt_device_info *dt_dev,
 	return !(odi->systemid_len || odi->osdname_len);
 }
 
-int __alloc_dev_table(struct exofs_sb_info *sbi, unsigned numdevs,
-		      struct exofs_dev **peds)
+static int __alloc_dev_table(struct exofs_sb_info *sbi, unsigned numdevs,
+			     struct exofs_dev **peds)
 {
 	struct __alloc_ore_devs_and_exofs_devs {
 		/* Twice bigger table: See exofs_init_comps() and comment at
-- 
1.7.9.5

