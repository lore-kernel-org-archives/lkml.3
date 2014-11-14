Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934606AbaKNAie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:38:34 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:33599 "HELO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933781AbaKNAid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:38:33 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: sathya.perla@emulex.com, shahed.shaikh@qlogic.com, amirv@mellanox.com,
        Dept-GELinuxNICDev@qlogic.com, therbert@google.com,
        gerlitz.or@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCHv2 net 0/4] Implement ndo_gso_check() for vxlan nics
Date: Thu, 13 Nov 2014 16:38:11 -0800
Message-Id: <1415925495-59312-1-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most NICs that report NETIF_F_GSO_UDP_TUNNEL support VXLAN, and not other
UDP-based encapsulation protocols where the format and size of the header may
differ. This patch series implements a generic ndo_gso_check() for detecting
VXLAN, then reuses it for these NICs.

Implementation shamelessly stolen from Tom Herbert (with minor fixups):
http://thread.gmane.org/gmane.linux.network/332428/focus=333111

v2: Drop i40e/fm10k patches (code diverged; handling separately).
    Refactor common code into vxlan_gso_check() helper.
    Minor style fixes.

Joe Stringer (4):
  net: Add vxlan_gso_check() helper
  be2net: Implement ndo_gso_check()
  net/mlx4_en: Implement ndo_gso_check()
  qlcnic: Implement ndo_gso_check()

 drivers/net/ethernet/emulex/benet/be_main.c      |    6 ++++++
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |    6 ++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    6 ++++++
 drivers/net/vxlan.c                              |   13 +++++++++++++
 include/net/vxlan.h                              |    2 ++
 5 files changed, 33 insertions(+)

-- 
1.7.10.4

