Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab3BGNI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:08:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758369Ab3BGNIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:08:52 -0500
Date: Thu, 7 Feb 2013 15:12:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org
Cc: Eilon Greenstein <eilong@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, linux-driver@qlogic.com,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, bhutchings@solarflare.com,
        eric.dumazet@gmail.com
Subject: [PATCHv2-net-3.8 0/3] fix kernel crash with macvtap on top of LRO
Message-ID: <cover.1360236441.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, macvtap crashes are observed if macvtap is attached
to an interface with LRO enabled.
The crash in question is BUG() in macvtap_skb_to_vnet_hdr.
This happens because several drivers set gso_size but not gso_type
in incoming skbs.
This didn't use to be the case: with intel cards on 3.2 and older
kernels, with qlogic - on 3.4 and older kernels, so it's a regression if
not a recent one.
The following patches fix this for qlogic, broadcom and intel drivers.

I tested that the patch fixes the crash for ixgbe but
don't have qlogic/broadcom hardware to test.
I also only tested TCPv4.

Please review, and consider for 3.8.

Changes from v1:
	- added missing htons as suggested by Eric
	- backported the relevant bits from
	  cbf1de72324a8105ddcc3d9ce9acbc613faea17e for bnx2x

Michael S. Tsirkin (3):
  ixgbe: fix gso type
  qlcnic: set gso_type
  bnx2x: set gso_type

 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 12 +++++-------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |  8 ++++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c  |  7 ++++++-
 3 files changed, 17 insertions(+), 10 deletions(-)

-- 
MST
