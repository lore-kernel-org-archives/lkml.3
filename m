Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933896Ab3AOWxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:53:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:47369 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933645Ab3AOWxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 160/171] rbd: BUG on invalid layout
Date: Tue, 15 Jan 2013 14:45:25 -0800
Message-Id: <20130115224324.875621848@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sage Weil <sage@inktank.com>

This shouldn't actually be possible because the layout struct is
constructed from the RBD header and validated then.

[elder@inktank.com: converted BUG() call to equivalent rbd_assert()]

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(based on commit 6cae3717cddaf8e5e96e304733dca66e40d56f89)
---
 drivers/block/rbd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -930,8 +930,9 @@ static int rbd_do_request(struct request
 	layout->fl_object_size = cpu_to_le32(1 << RBD_MAX_OBJ_ORDER);
 	layout->fl_pg_preferred = cpu_to_le32(-1);
 	layout->fl_pg_pool = cpu_to_le32(dev->poolid);
-	ceph_calc_raw_layout(osdc, layout, snapid, ofs, &len, &bno,
-				req, ops);
+	ret = ceph_calc_raw_layout(osdc, layout, snapid, ofs, &len, &bno,
+				   req, ops);
+	BUG_ON(ret != 0);
 
 	ceph_osdc_build_request(req, ofs, &len,
 				ops,


