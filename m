Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaAMQfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:35:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53385 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaAMQDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 119/208] libceph: potential NULL dereference in ceph_osdc_handle_map()
Date: Mon, 13 Jan 2014 15:59:20 +0000
Message-Id: <1389628849-1614-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b72e19b9225d4297a18715b0998093d843d170fa upstream.

There are two places where we read "nr_maps" if both of them are set to
zero then we would hit a NULL dereference here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ceph/osd_client.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 559a832..56f1fe5 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1786,6 +1786,8 @@ void ceph_osdc_handle_map(struct ceph_osd_client *osdc, struct ceph_msg *msg)
 		nr_maps--;
 	}
 
+	if (!osdc->osdmap)
+		goto bad;
 done:
 	downgrade_write(&osdc->map_sem);
 	ceph_monc_got_osdmap(&osdc->client->monc, osdc->osdmap->epoch);
-- 
1.8.3.2

