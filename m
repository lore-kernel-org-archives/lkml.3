Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3BFW6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:58:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757045Ab3BFW6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:58:40 -0500
Date: Thu, 7 Feb 2013 01:02:38 +0200
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
Subject: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
Message-ID: <cover.1360191528.git.mst@redhat.com>
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
The following patches fix this for
Additionally, cbf1de72324a8105ddcc3d9ce9acbc613faea17e is required
to fix this for broadcom - would it make sense to cherry-pick
this patch into 3.8?

I tested that the patch fixes the crash for ixgbe but
don't have qlogic hardware to fix.  I also only tested TCP.

Feedback wellcome.

Michael S. Tsirkin (2):
  ixgbe: fix gso type
  qlcnic: set gso_type

 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  | 8 ++++++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 7 ++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

-- 
MST
