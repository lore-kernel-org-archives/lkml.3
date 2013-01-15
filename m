Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804Ab3AOWxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:53:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:47206 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Durgin <josh.durgin@dreamhost.com>,
        Alex Elder <elder@inktank.com>
Subject: [ 136/171] rbd: set image size when header is updated
Date: Tue, 15 Jan 2013 14:45:01 -0800
Message-Id: <20130115224323.157375556@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Josh Durgin <josh.durgin@dreamhost.com>

The image may have been resized.

Signed-off-by: Josh Durgin <josh.durgin@dreamhost.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(cherry picked from commit 93a24e084d67ba2fcb9a4c289135825b623ec864)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1741,6 +1741,7 @@ static int __rbd_update_snaps(struct rbd
 	kfree(rbd_dev->header.snap_names);
 	kfree(rbd_dev->header.snap_sizes);
 
+	rbd_dev->header.image_size = h.image_size;
 	rbd_dev->header.total_snaps = h.total_snaps;
 	rbd_dev->header.snapc = h.snapc;
 	rbd_dev->header.snap_names = h.snap_names;


