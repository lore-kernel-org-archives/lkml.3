Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab3KTJcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:32:41 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50250 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3KTJbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:31:12 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.38 with qID rAK9V5QU013302, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v5 0/4] r8152 bug fixes
Date: Wed, 20 Nov 2013 17:30:53 +0800
Message-ID: <1384939857-13519-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384502279-9959-1-git-send-email-hayeswang@realtek.com>
References: <1384502279-9959-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the patch #3, I add netif_tx_lock() before checking the
netif_queue_stopped(). Besides, I add checking the skb queue
length before waking the tx queue.

Hayes Wang (4):
  r8152: fix tx/rx memory overflow
  r8152: modify the tx flow
  r8152: support stopping/waking tx queue
  r8152: fix incorrect type in assignment

 drivers/net/usb/r8152.c | 114 +++++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 64 deletions(-)

-- 
1.8.3.1

