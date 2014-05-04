Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaEDWoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 18:44:24 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:58864 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaEDWoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 18:44:22 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        git@xilinx.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH 0/5] net: macb: Fixes
Date: Sun,  4 May 2014 15:42:57 -0700
Message-Id: <1399243382-12528-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.2.1.g06c4abd
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Nicolas,

I think I found the cause of the issue I told you about. Looks like
driver and HW are racing (a few more details in the commit message).
On my way finding that, I found a few more minor issues which are fixed
in the first patches.
The last one is "fixing" the actual race. I don't know if I overlooked
anything here, but this seems to work fine on Zynq.

	Thanks,
	Sören


Soren Brinkmann (5):
  net: macb: Pass same size to DMA_UNMAP as used for DMA_MAP
  net: macb: Clear interrupt flags
  net: macb: Re-enable RX interrupt only when RX is done
  net: macb: Remove 'unlikely' optimization
  net: macb: Fix race between HW and driver

 drivers/net/ethernet/cadence/macb.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

-- 
1.9.2.1.g06c4abd

