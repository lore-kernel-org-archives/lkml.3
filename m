Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaKTC3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 21:29:38 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33126 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaKTC3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 21:29:36 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAK2TNwC022005, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 0/2] r8152: adjust rx functions
Date: Thu, 20 Nov 2014 10:29:04 +0800
Message-ID: <1394712342-15778-98-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-88-Taiwan-albertk@realtek.com>
References: <1394712342-15778-88-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3:
For patch #1, remove unnecessary initialization for ret and
unnecessary blank line in r8152_submit_rx().

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

