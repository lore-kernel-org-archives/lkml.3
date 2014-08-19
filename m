Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaHSGjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:39:37 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:51215 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaHSGjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:39:36 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>,
        "dsd@gentoo.org" <dsd@gentoo.org>,
        "kune@deine-taler.de" <kune@deine-taler.de>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()
Thread-Topic: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()
Thread-Index: AQHPtfoBVk8gAvJHtkG25CMeZOEP5JvXhG6Q
Date: Tue, 19 Aug 2014 06:39:29 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF2FDC2@EU-MBX-02.mgc.mentorg.com>
References: <1407827133-29493-1-git-send-email-sanjeev_sharma@mentor.com>
In-Reply-To: <1407827133-29493-1-git-send-email-sanjeev_sharma@mentor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Aug 2014 06:39:33.0116 (UTC) FILETIME=[560C73C0:01CFBB78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping for review the patch.

thanks,

Sanjeev Sharma
-----Original Message-----
From: Sanjeev Sharma [mailto:sanjeev_sharma@mentor.com] 
Sent: Tuesday, August 12, 2014 12:36 PM
To: dsd@gentoo.org; kune@deine-taler.de
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sharma, Sanjeev; Sharma, Sanjeev
Subject: [PATCH] zd1211rw: replace ZD_ASSERT with lockdep_assert_held()

on some architecture spin_is_locked() always return false in uniprocessor configuration and therefore it would be advise to replace with lockdep_assert_held().

Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
---
 drivers/net/wireless/zd1211rw/zd_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index e7af261..72c0bc2 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -235,7 +235,7 @@ void zd_mac_clear(struct zd_mac *mac)  {
 	flush_workqueue(zd_workqueue);
 	zd_chip_clear(&mac->chip);
-	ZD_ASSERT(!spin_is_locked(&mac->lock));
+	lockdep_assert_held(!spin_is_locked(&mac->lock));
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));  }
 
--
1.7.11.7

