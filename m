Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933021Ab3AOWjK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:39:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:44046 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934Ab3AOWgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Josh Durgin <josh.durgin@inktank.com>
Subject: [ 205/221] rbd: fix bug in rbd_dev_id_put()
Date: Tue, 15 Jan 2013 10:52:12 -0800
Message-Id: <20130115185012.830008907@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

(cherry picked from commit b213e0b1a62637b2a9395a34349b13d73ca2b90a)

In rbd_dev_id_put(), there's a loop that's intended to determine
the maximum device id in use.  But it isn't doing that at all,
the effect of how it's written is to simply use the just-put id
number, which ignores whole purpose of this function.

Fix the bug.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -2621,8 +2621,8 @@ static void rbd_dev_id_put(struct rbd_de
 		struct rbd_device *rbd_dev;
 
 		rbd_dev = list_entry(tmp, struct rbd_device, node);
-		if (rbd_id > max_id)
-			max_id = rbd_id;
+		if (rbd_dev->dev_id > max_id)
+			max_id = rbd_dev->dev_id;
 	}
 	spin_unlock(&rbd_dev_list_lock);
 


