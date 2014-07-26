Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaGZTDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:03:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaGZTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:02:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Assmann <sassmann@kpanic.de>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 11/56] igb: do a reset on SR-IOV re-init if device is down
Date: Sat, 26 Jul 2014 12:02:04 -0700
Message-Id: <20140726190200.411934781@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Assmann <sassmann@kpanic.de>

commit 76252723e88681628a3dbb9c09c963e095476f73 upstream.

To properly re-initialize SR-IOV it is necessary to reset the device
even if it is already down. Not doing this may result in Tx unit hangs.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/igb/igb_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7229,6 +7229,8 @@ static int igb_sriov_reinit(struct pci_d
 
 	if (netif_running(netdev))
 		igb_close(netdev);
+	else
+		igb_reset(adapter);
 
 	igb_clear_interrupt_scheme(adapter);
 


