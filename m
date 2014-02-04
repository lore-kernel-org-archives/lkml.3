Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935806AbaBDWTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:19:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933932AbaBDVIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3.12 052/133] staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning
Date: Tue,  4 Feb 2014 13:07:33 -0800
Message-Id: <20140204210738.504750282@linuxfoundation.org>
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

commit 8f248dae133668bfb8e9379b4b3f0571c858b24a upstream.

byBBPreEDIndex value is initially 0, this means that from
cold BBvUpdatePreEDThreshold is never set.

This means that sensitivity may be in an ambiguous state,
failing to scan any wireless points or at least distant ones.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/baseband.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1464,7 +1464,6 @@ void BBvUpdatePreEDThreshold(struct vnt_
 
             if( bScanning )
             {   // need Max sensitivity //RSSI -69, -70,....
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
@@ -1607,7 +1606,6 @@ void BBvUpdatePreEDThreshold(struct vnt_
 
             if( bScanning )
             {   // need Max sensitivity  //RSSI -69, -70, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
@@ -1759,7 +1757,6 @@ void BBvUpdatePreEDThreshold(struct vnt_
         case RF_VT3342A0: //RobertYu:20060627, testing table
             if( bScanning )
             {   // need Max sensitivity  //RSSI -67, -68, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)


