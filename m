Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbaJIKAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 06:00:49 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:47390 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaJIKAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 06:00:38 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s99A0Y6J027969, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 0/3] r8152: use mutex for hw settings
Date: Thu, 9 Oct 2014 18:00:23 +0800
Message-ID: <1394712342-15778-60-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-58-Taiwan-albertk@realtek.com>
References: <1394712342-15778-58-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
Make sure the autoresume wouldn't occur inside the mutex, otherwise
the dead lock would happen. For the purpose, adjust some code about
autosuspend/autoresume.

v1:
Use mutex to avoid that the serial hw settings would be interrupted
by other settings. Although there is no problem now, it makes the
driver more safe.

Hayes Wang (3):
  r8152: autoresume before setting feature
  r8152: adjust usb_autopm_xxx
  r8152: add mutex for hw settings

 drivers/net/usb/r8152.c | 98 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 83 insertions(+), 15 deletions(-)

-- 
1.9.3

