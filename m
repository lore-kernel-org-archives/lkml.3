Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815Ab3CNKtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:49:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51962 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab3CNKhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 53/88] md: raid0: fix error return from create_stripe_zones.
Date: Thu, 14 Mar 2013 10:35:46 +0000
Message-Id: <1363257381-15900-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 58ebb34c49fcfcaa029e4b1c1453d92583900f9a upstream.

Create_stripe_zones returns an error slightly differently to
raid0_run and to raid0_takeover_*.

The error returned used by the second was wrong and an error would
result in mddev->private being set to NULL and sooner or later a
crash.

So never return NULL, return ERR_PTR(err), not NULL from
create_stripe_zones.

This bug has been present since 2.6.35 so the fix is suitable
for any kernel since then.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 08e1734..06a0257 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -280,7 +280,7 @@ abort:
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	*private_conf = NULL;
+	*private_conf = ERR_PTR(err);
 	return err;
 }
 
-- 
1.8.1.2

