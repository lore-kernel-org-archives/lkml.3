Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3CREbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33355 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab3CREaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:01 -0400
Message-Id: <20130318042145.344260218@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, NeilBrown <neilb@suse.de>
Subject: [ 11/82] md: raid0: fix error return from create_stripe_zones.
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -286,7 +286,7 @@ abort:
 	kfree(conf->strip_zone);
 	kfree(conf->devlist);
 	kfree(conf);
-	*private_conf = NULL;
+	*private_conf = ERR_PTR(err);
 	return err;
 }
 


