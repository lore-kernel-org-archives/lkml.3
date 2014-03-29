Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbaC2R5d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 13:57:33 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37274 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbaC2R5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 13:57:31 -0400
Date: Sat, 29 Mar 2014 23:27:57 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Eddie Wai <eddie.wai@broadcom.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 13/55] scsi: Mark function as static in bnx2fc/bnx2fc_fcoe.c
Message-ID: <f0a108415a2e0866240c99d543ba1250c26812b2.1396114897.git.rashika.kheria@gmail.com>
References: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fd6fa49a592043459f75ed83a72f8c1ed9ddc13.1396114897.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in bnx2fc/bnx2fc_fcoe.c because they are not
used outside this file.

This eliminates the following warnings in bnx2fc/bnx2fc_fcoe.c:
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:599:5: warning: no previous prototype for ‘bnx2fc_percpu_io_thread’ [-Wmissing-prototypes]
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1365:26: warning: no previous prototype for ‘bnx2fc_interface_create’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 9b94850..b03f0c6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -596,7 +596,7 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
  *
  * @arg:	ptr to bnx2fc_percpu_info structure
  */
-int bnx2fc_percpu_io_thread(void *arg)
+static int bnx2fc_percpu_io_thread(void *arg)
 {
 	struct bnx2fc_percpu_s *p = arg;
 	struct bnx2fc_work *work, *tmp;
@@ -1362,9 +1362,9 @@ bind_err:
 	return NULL;
 }
 
-struct bnx2fc_interface *bnx2fc_interface_create(struct bnx2fc_hba *hba,
-				      struct net_device *netdev,
-				      enum fip_state fip_mode)
+static struct bnx2fc_interface *bnx2fc_interface_create(struct bnx2fc_hba *hba,
+						struct net_device *netdev,
+				      		enum fip_state fip_mode)
 {
 	struct fcoe_ctlr_device *ctlr_dev;
 	struct bnx2fc_interface *interface;
-- 
1.7.9.5

