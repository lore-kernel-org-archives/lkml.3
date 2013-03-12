Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab3CLW4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:56:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933210Ab3CLWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [ 18/40] md: raid0: fix error return from create_stripe_zones.
Date: Tue, 12 Mar 2013 15:43:39 -0700
Message-Id: <20130312223213.468598555@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223211.492954675@linuxfoundation.org>
References: <20130312223211.492954675@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 


