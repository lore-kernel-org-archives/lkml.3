Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaBGLYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:24:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40905 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaBGLX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:23:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 21/88] staging: vt6656: [BUG] BBvUpdatePreEDThreshold Always set sensitivity on bScanning
Date: Fri,  7 Feb 2014 11:22:18 +0000
Message-Id: <1391772205-22239-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 8f248dae133668bfb8e9379b4b3f0571c858b24a upstream.

byBBPreEDIndex value is initially 0, this means that from
cold BBvUpdatePreEDThreshold is never set.

This means that sensitivity may be in an ambiguous state,
failing to scan any wireless points or at least distant ones.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/vt6656/baseband.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 858e2a8..4034281 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1634,7 +1634,6 @@ BBvUpdatePreEDThreshold(
 
             if( bScanning )
             {   // need Max sensitivity //RSSI -69, -70,....
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x30); //CR206(0xCE)
@@ -1777,7 +1776,6 @@ BBvUpdatePreEDThreshold(
 
             if( bScanning )
             {   // need Max sensitivity  //RSSI -69, -70, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x24); //CR206(0xCE)
@@ -1929,7 +1927,6 @@ BBvUpdatePreEDThreshold(
         case RF_VT3342A0: //RobertYu:20060627, testing table
             if( bScanning )
             {   // need Max sensitivity  //RSSI -67, -68, ...
-                if(pDevice->byBBPreEDIndex == 0) break;
                 pDevice->byBBPreEDIndex = 0;
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xC9, 0x00); //CR201(0xC9)
                 ControlvWriteByte(pDevice, MESSAGE_REQUEST_BBREG, 0xCE, 0x38); //CR206(0xCE)
-- 
1.8.3.2

