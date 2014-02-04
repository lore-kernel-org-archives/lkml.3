Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbaBDWYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:24:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899AbaBDVIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikhail Zolotaryov <lebon@lebon.org.ua>
Subject: [PATCH 3.12 023/133] USB: Nokia 502 is an unusual device
Date: Tue,  4 Feb 2014 13:07:04 -0800
Message-Id: <20140204210737.681741554@linuxfoundation.org>
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

---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -234,6 +234,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x
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


