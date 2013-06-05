Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3FEH5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 03:57:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:15654 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3FEH5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 03:57:15 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <hein_tibosch@yahoo.es>, <s.trumtrar@pengutronix.de>,
        <michal.simek@xilinx.com>, <monstr@monstr.eu>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/2 v4] net/macb: RX path enhancement
Date: Wed, 5 Jun 2013 09:57:10 +0200
Message-ID: <cover.1370418770.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the patch series for modifying the RX path in macb driver.
This change applies on GEM variant of the Cadence IP and introduces
function pointers to match the path to the proper adapter. The move
to RX buffers adapted to MTU and that can be DMAed directly in SKB
is done in two steps but can be merged in a single patch.

v4: - rebased on top of net-next
    - removed the last patch of the series which needs rework

v3: - rebased on top of net-next (containing recently added
      net/macb: fix ISR clear-on-write behavior only for some SoC)
    - added the ___cacheline_aligned_in_smp qualifier to napi field
      following Ben Hutchings' advice

v2: - gave up the idea of using non-coherent memory for
      rx buffers
    - addition of the struct macb layout optimization


Nicolas Ferre (2):
  net/macb: increase RX buffer size for GEM
  net/macb: change RX path for GEM

 drivers/net/ethernet/cadence/macb.c | 323 +++++++++++++++++++++++++++++++-----
 drivers/net/ethernet/cadence/macb.h |  14 ++
 2 files changed, 295 insertions(+), 42 deletions(-)

-- 
1.8.2.2

