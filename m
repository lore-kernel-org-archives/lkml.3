Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaKSFVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 00:21:31 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:40660 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaKSFV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 00:21:28 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAJ5LCxr019032, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 0/2] r8152: adjust rx functions
Date: Wed, 19 Nov 2014 13:20:40 +0800
Message-ID: <1394712342-15778-95-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-88-Taiwan-albertk@realtek.com>
References: <1394712342-15778-88-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
For patch #1, set actual_length to 0 before adding the rx to the
list, when a error occurs.

For patch #2, change the flow. Stop submitting the rx if a error
occurs, and add the remaining rx to the list for submitting later.

v1:
Adjust some flows and codes which are relative to r8152_submit_rx()
and rtl_start_rx().

Hayes Wang (2):
  r8152: adjust r8152_submit_rx
  r8152: adjust rtl_start_rx

 drivers/net/usb/r8152.c | 60 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 20 deletions(-)

-- 
1.9.3

