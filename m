Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbaC2SDs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 14:03:48 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51679 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaC2SDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 14:03:47 -0400
Date: Sat, 29 Mar 2014 23:34:11 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>,
        Lukasz Dorau <lukasz.dorau@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 19/55] scsi: Mark function as static in isci/phy.c
Message-ID: <aeac50e3686d8daafd573ebd08805b8a97d85ebd.1396114898.git.rashika.kheria@gmail.com>
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

Mark function as static in isci/phy.c because it is not used outside
this file.

This eliminates the following warning in isci/phy.c:
drivers/scsi/isci/phy.c:672:6: warning: no previous prototype for ‘scu_link_layer_set_txcomsas_timeout’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/scsi/isci/phy.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index cb87b2e..8e21022 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -669,7 +669,8 @@ static const char *phy_event_name(u32 event_code)
 		phy_state_name(state), phy_event_name(code), code)
 
 
-void scu_link_layer_set_txcomsas_timeout(struct isci_phy *iphy, u32 timeout)
+static void scu_link_layer_set_txcomsas_timeout(struct isci_phy *iphy,
+						u32 timeout)
 {
 	u32 val;
 
-- 
1.7.9.5

