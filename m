Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbaLNUva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:51:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaLNUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Todd Fujinaka <todd.fujinaka@intel.com>,
        Jeff Westfahl <jeff.westfahl@ni.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Vincent Donnefort <vdonnefort@gmail.com>
Subject: [PATCH 3.10 21/24] igb: bring link up when PHY is powered up
Date: Sun, 14 Dec 2014 12:20:41 -0800
Message-Id: <20141214201801.315822683@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Todd Fujinaka <todd.fujinaka@intel.com>

commit aec653c43b0c55667355e26d7de1236bda9fb4e3 upstream.

Call igb_setup_link() when the PHY is powered up.

Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
Reported-by: Jeff Westfahl <jeff.westfahl@ni.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Vincent Donnefort <vdonnefort@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/igb/igb_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1584,6 +1584,8 @@ void igb_power_up_link(struct igb_adapte
 		igb_power_up_phy_copper(&adapter->hw);
 	else
 		igb_power_up_serdes_link_82575(&adapter->hw);
+
+	igb_setup_link(&adapter->hw);
 }
 
 /**


