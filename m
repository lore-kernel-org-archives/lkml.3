Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaCaPBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:01:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:43861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaCaPBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:01:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,766,1389772800"; 
   d="scan'208";a="484041559"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 2/2] mei: make return values consistent across the driver
Date: Mon, 31 Mar 2014 17:59:24 +0300
Message-Id: <1396277964-25314-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396277964-25314-1-git-send-email-tomas.winkler@intel.com>
References: <1396277964-25314-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Follow-up for bits missed in
commit 7ca96aa278f8b9983184e318b06a0ed9ad0297b8
mei: make return values consistent across the driver

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c    | 2 +-
 drivers/misc/mei/client.c | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index ddc5ac9..d5b9ed4 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -247,7 +247,7 @@ static int ___mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length,
 		return id;
 
 	if (length > dev->me_clients[id].props.max_msg_length)
-		return -EINVAL;
+		return -EFBIG;
 
 	cb = mei_io_cb_init(cl, NULL);
 	if (!cb)
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 0c70459..4c06ceb 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -768,10 +768,9 @@ int mei_cl_read_start(struct mei_cl *cl, size_t length)
 
 	cb->fop_type = MEI_FOP_READ;
 	if (mei_hbuf_acquire(dev)) {
-		if (mei_hbm_cl_flow_control_req(dev, cl)) {
-			rets = -ENODEV;
+		rets = mei_hbm_cl_flow_control_req(dev, cl);
+		if (rets < 0)
 			goto out;
-		}
 
 		list_add_tail(&cb->list, &dev->read_list.list);
 	} else {
-- 
1.9.0

