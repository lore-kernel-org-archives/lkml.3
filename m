Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933874Ab3AOXVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:21:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:47311 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933841Ab3AOWx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Sage Weil <sage@inktank.com>
Subject: [ 145/171] libceph: init event->node in ceph_osdc_create_event()
Date: Tue, 15 Jan 2013 14:45:10 -0800
Message-Id: <20130115224323.804263041@linuxfoundation.org>
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

The red-black node node in the ceph osd event structure is not
initialized in create_osdc_create_event().  Because this node can
be the subject of a RB_EMPTY_NODE() call later on, we should ensure
the node is initialized properly for that.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
(cherry picked from commit 3ee5234df68d253c415ba4f2db72ad250d9c21a9)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osd_client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1598,6 +1598,7 @@ int ceph_osdc_create_event(struct ceph_o
 	event->data = data;
 	event->osdc = osdc;
 	INIT_LIST_HEAD(&event->osd_node);
+	RB_CLEAR_NODE(&event->node);
 	kref_init(&event->kref);   /* one ref for us */
 	kref_get(&event->kref);    /* one ref for the caller */
 	init_completion(&event->completion);


