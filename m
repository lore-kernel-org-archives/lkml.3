Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab3ETGvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:51:14 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:54001 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3ETGvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:51:10 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] net/9p: Use virtio transpart as the default transport
Date: Mon, 20 May 2013 12:20:55 +0530
Message-Id: <1369032655-22648-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369032655-22648-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1369032655-22648-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052006-2674-0000-0000-00000908BD38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Make the default 9p experience better by defaulting to virtio transport if present.
These days most of the users are using 9p in a virtualized setup

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/client.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index 812a4cd..5e94dab 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1015,6 +1015,9 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 		goto destroy_tagpool;
 
 	if (!clnt->trans_mod)
+		clnt->trans_mod = v9fs_get_trans_by_name("virtio");
+
+	if (!clnt->trans_mod)
 		clnt->trans_mod = v9fs_get_default_trans();
 
 	if (clnt->trans_mod == NULL) {
-- 
1.8.1.2

