Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab3AOWfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:35:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:43686 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702Ab3AOWfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 192/221] libceph: init osd->o_node in create_osd()
Date: Tue, 15 Jan 2013 10:51:59 -0800
Message-Id: <20130115185011.890285374@linuxfoundation.org>
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

(cherry picked from commit f407731d12214e7686819018f3a1e9d7b6f83a02)

The red-black node node in the ceph osd structure is not initialized
in create_osd().  Because this node can be the subject of a
RB_EMPTY_NODE() call later on, we should ensure the node is
initialized properly for that.  Add a call to RB_CLEAR_NODE()
initialize it.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -647,6 +647,7 @@ static struct ceph_osd *create_osd(struc
 	atomic_set(&osd->o_ref, 1);
 	osd->o_osdc = osdc;
 	osd->o_osd = onum;
+	RB_CLEAR_NODE(&osd->o_node);
 	INIT_LIST_HEAD(&osd->o_requests);
 	INIT_LIST_HEAD(&osd->o_linger_requests);
 	INIT_LIST_HEAD(&osd->o_osd_lru);


