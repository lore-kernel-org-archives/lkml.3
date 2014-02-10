Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaBJTvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:51:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35140 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbaBJTr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:47:28 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikhail Zolotaryov <lebon@lebon.org.ua>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 026/124] USB: Nokia 502 is an unusual device
Date: Mon, 10 Feb 2014 11:39:26 -0800
Message-Id: <1392061264-28124-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Zolotaryov <lebon@lebon.org.ua>

commit 0e16114f2db4838251fb64f3b550996ad3585890 upstream.

The USB storage operation of Nokia Asha 502 Dual SIM smartphone running Asha
Platform 1.1.1 is unreliable in respect of data consistency (i.e. transfered
files are corrupted). A similar issue is described here:
http://discussions.nokia.com/t5/Asha-and-other-Nokia-Series-30/Nokia-301-USB-transfers-and-corrupted-files/td-p/1974170

The workaround is (MAX_SECTORS_64):
   rmmod usb_storage && modprobe usb_storage quirks=0421:06aa:m

The patch adds the tested device to the unusual list permanently.

Signed-off-by: Mikhail Zolotaryov <lebon@lebon.org.ua>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index df8c74b..3224305 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -226,6 +226,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x0370,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_MAX_SECTORS_64 ),
 
+/* Patch submitted by Mikhail Zolotaryov <lebon@lebon.org.ua> */
+UNUSUAL_DEV(  0x0421, 0x06aa, 0x1110, 0x1110,
+		"Nokia",
+		"502",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_MAX_SECTORS_64 ),
+
 #ifdef NO_SDDR09
 UNUSUAL_DEV(  0x0436, 0x0005, 0x0100, 0x0100,
 		"Microtech",
-- 
1.8.3.2

