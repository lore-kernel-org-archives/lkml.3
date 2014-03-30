Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaCaAei (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:34:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36217 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752801AbaC3XY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Malcolm Priestley" <tvboxspy@gmail.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.698291000@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 006/200] staging: vt6656: [BUG] BBvUpdatePreEDThreshold
 Always set sensitivity on bScanning
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 8f248dae133668bfb8e9379b4b3f0571c858b24a upstream.

byBBPreEDIndex value is initially 0, this means that from
cold BBvUpdatePreEDThreshold is never set.

This means that sensitivity may be in an ambiguous state,
failing to scan any wireless points or at least distant ones.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/vt6656/baseband.c | 3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1656,7 +1656,6 @@ BBvUpdatePreEDThreshold(
 
             if( bScanning )
             {   // need Max sensitivity //RSSI -69, -70,....
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
@@ -1799,7 +1798,6 @@ BBvUpdatePreEDThreshold(
 
             if( bScanning )
             {   // need Max sensitivity  //RSSI -69, -70, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
@@ -1951,7 +1949,6 @@ BBvUpdatePreEDThreshold(
         case RF_VT3342A0: //RobertYu:20060627, testing table
             if( bScanning )
             {   // need Max sensitivity  //RSSI -67, -68, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)

