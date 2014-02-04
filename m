Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935792AbaBDWTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:19:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaBDVId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3.12 053/133] staging: vt6656: CARDqGetNextTBTT correct uLowNextTBTT
Date: Tue,  4 Feb 2014 13:07:34 -0800
Message-Id: <20140204210738.532653222@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 9acec059c0cef0bf086c738f4c0b1f4447782a48 upstream.

value uLowNextTBTT yields wrong value.

ULL is needed with qwTSF

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -731,7 +731,7 @@ u64 CARDqGetNextTBTT(u64 qwTSF, u16 wBea
 
     uBeaconInterval = wBeaconInterval * 1024;
     // Next TBTT = ((local_current_TSF / beacon_interval) + 1 ) * beacon_interval
-	uLowNextTBTT = ((qwTSF & 0xffffffffU) >> 10) << 10;
+	uLowNextTBTT = ((qwTSF & 0xffffffffULL) >> 10) << 10;
 	uLowRemain = (uLowNextTBTT) % uBeaconInterval;
 	uHighRemain = ((0x80000000 % uBeaconInterval) * 2 * (u32)(qwTSF >> 32))
 		% uBeaconInterval;


