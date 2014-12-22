Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaLVGxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 01:53:30 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57358 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaLVGx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 01:53:28 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID sBM6rOaR028035, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH net-next v2 0/2] r8152: adjust r8152_submit_rx
Date: Mon, 22 Dec 2014 14:52:54 +0800
Message-ID: <1394712342-15778-110-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-107-Taiwan-albertk@realtek.com>
References: <1394712342-15778-107-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.83]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
Replace the patch #1 with "call rtl_start_rx after netif_carrier_on".

For patch #2, replace checking tp->speed with netif_carrier_ok.

v1:
Avoid r8152_submit_rx() from submitting rx during unexpected
moment. This could reduce the time of stopping rx.

For patch #1, the tp->speed should be updated early. Then,
the patch #2 could use it to check the current linking status.

Hayes Wang (2):
  r8152: call rtl_start_rx after netif_carrier_on
  r8152: check the status before submitting rx

 drivers/net/usb/r8152.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.1.0

