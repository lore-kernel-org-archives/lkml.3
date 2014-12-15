Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaLOO3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:29:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbaLOO33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Todd Fujinaka <todd.fujinaka@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 168/168] igb: bring link up when PHY is powered up
Date: Mon, 15 Dec 2014 14:27:02 +0000
Message-Id: <1418653622-21105-169-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Todd Fujinaka <todd.fujinaka@intel.com>

commit aec653c43b0c55667355e26d7de1236bda9fb4e3 upstream.

Call igb_setup_link() when the PHY is powered up.

Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
Reported-by: Jeff Westfahl <jeff.westfahl@ni.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a9537ba7a5a0..4d2dc17fd31b 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1630,6 +1630,8 @@ void igb_power_up_link(struct igb_adapter *adapter)
 		igb_power_up_phy_copper(&adapter->hw);
 	else
 		igb_power_up_serdes_link_82575(&adapter->hw);
+
+	igb_setup_link(&adapter->hw);
 }
 
 /**
-- 
2.1.3

