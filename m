Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbaCGDE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 22:04:57 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43373 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaCGDEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 22:04:55 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2734qUc029673, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/7] r8152: tx/rx improvement
Date: Fri, 7 Mar 2014 11:04:33 +0800
Message-ID: <1394161480-2918-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
References: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - Select the suitable spin lock for each function.
 - Add additional check to reduce the spin lock.
 - Up the priority of the tx to avoid interrupted by rx.
 - Support rx checksum, large send, and IPv6 hw checksum.

Hayes Wang (7):
  r8152: replace spin_lock_irqsave and spin_unlock_irqrestore
  r8152: check tx agg list before spin lock
  r8152: up the priority of the transmission
  r8152: calculate the dropped packets for rx
  r8152: support rx checksum
  r8152: support TSO
  r8152: support IPv6

 drivers/net/usb/r8152.c | 323 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 263 insertions(+), 60 deletions(-)

-- 
1.8.4.2

