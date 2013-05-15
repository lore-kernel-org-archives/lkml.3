Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab3EOJSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:18:54 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:1772 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3EOJSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:18:52 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <hein_tibosch@yahoo.es>, <s.trumtrar@pengutronix.de>,
        <michal.simek@xilinx.com>, <monstr@monstr.eu>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 0/3 v3] net/macb: RX path enhancement
Date: Wed, 15 May 2013 11:18:45 +0200
Message-ID: <cover.1368608928.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
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

v3: - rebased on top of net-next (containing recently added
      net/macb: fix ISR clear-on-write behavior only for some SoC)
    - added the ___cacheline_aligned_in_smp qualifier to napi field
      following Ben Hutchings' advice

v2: - gave up the idea of using non-coherent memory for
      rx buffers
    - addition of the struct macb layout optimization

Havard Skinnemoen (1):
  net/macb: Try to optimize struct macb layout

Nicolas Ferre (2):
  net/macb: increase RX buffer size for GEM
  net/macb: change RX path for GEM

 drivers/net/ethernet/cadence/macb.c | 323 +++++++++++++++++++++++++++++++-----
 drivers/net/ethernet/cadence/macb.h |  39 +++--
 2 files changed, 308 insertions(+), 54 deletions(-)

-- 
1.8.0

