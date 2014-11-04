Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaKDWDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 17:03:05 -0500
Received: from na6sys009bog022.obsmtp.com ([74.125.150.84]:38635 "HELO
	na6sys009bog022.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751832AbaKDWDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 17:03:00 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: sathya.perla@emulex.com, jeffrey.t.kirsher@intel.com, linux.nics@intel.com,
        amirv@mellanox.com, shahed.shaikh@qlogic.com,
        Dept-GELinuxNICDev@qlogic.com, therbert@google.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/5] Implement ndo_gso_check() for vxlan nics
Date: Tue,  4 Nov 2014 13:56:37 -0800
Message-Id: <1415138202-1197-1-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most NICs that report NETIF_F_GSO_UDP_TUNNEL support VXLAN, and not other
UDP-based encapsulation protocols where the format and size of the header may
differ. This patch series implements ndo_gso_check() for these NICs,
restricting the GSO handling to something that looks and smells like VXLAN.

Implementation shamelessly stolen from Tom Herbert (with minor fixups):
http://thread.gmane.org/gmane.linux.network/332428/focus=333111

If there are particular differences for your driver on actual support, I'd like
to hear about it. I adjusted the i40e driver to report support with tunnel
headers of up to 64 octets, perhaps there are other specifics that I've missed.

Joe Stringer (5):
  be2net: Implement ndo_gso_check()
  i40e: Implement ndo_gso_check()
  fm10k: Implement ndo_gso_check()
  net/mlx4_en: Implement ndo_gso_check()
  qlcnic: Implement ndo_gso_check()

 drivers/net/ethernet/emulex/benet/be_main.c      |   12 ++++++++++++
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c  |   12 ++++++++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c      |   14 +++++++++++++-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c   |   12 ++++++++++++
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |   12 ++++++++++++
 5 files changed, 61 insertions(+), 1 deletion(-)

--
1.7.10.4
