Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933829Ab3AOXXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:23:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:47195 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933774Ab3AOWxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 144/171] libceph: init osd->o_node in create_osd()
Date: Tue, 15 Jan 2013 14:45:09 -0800
Message-Id: <20130115224323.733932980@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

The red-black node node in the ceph osd structure is not initialized
in create_osd().  Because this node can be the subject of a
RB_EMPTY_NODE() call later on, we should ensure the node is
initialized properly for that.  Add a call to RB_CLEAR_NODE()
initialize it.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
(cherry picked from commit f407731d12214e7686819018f3a1e9d7b6f83a02)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -645,6 +645,7 @@ static struct ceph_osd *create_osd(struc
 	atomic_set(&osd->o_ref, 1);
 	osd->o_osdc = osdc;
 	osd->o_osd = onum;
+	RB_CLEAR_NODE(&osd->o_node);
 	INIT_LIST_HEAD(&osd->o_requests);
 	INIT_LIST_HEAD(&osd->o_linger_requests);
 	INIT_LIST_HEAD(&osd->o_osd_lru);


