Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaLOONz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:13:55 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:13207 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaLOONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:13:37 -0500
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <nicolas.ferre@atmel.com>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <soren.brinkmann@xilinx.com>
CC: <linux-kernel@vger.kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 0/2] net/macb: fix multiqueue support patch up
Date: Mon, 15 Dec 2014 15:13:30 +0100
Message-ID: <cover.1418651689.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches is a fixup for the multiqueue support patch.

The first patch fixes a bug introduced by the multiqueue support patch.
The second one doesn't fix a bug but simplify the source code by removing
useless calls to devm_free_irq() since we use managed device resources for
IRQs.

They were applied on the net-next tree and tested with a sama5d36ek board.

Cyrille Pitchen (2):
  net/macb: fix misplaced call of free_netdev() in macb_remove()
  net/macb: remove useless calls of devm_free_irq()

 drivers/net/ethernet/cadence/macb.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

-- 
1.8.2.2

