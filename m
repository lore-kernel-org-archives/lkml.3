Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaCaAcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:32:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36226 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbaC3XY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Mikhail Zolotaryov" <lebon@lebon.org.ua>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.747322041@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 018/200] USB: Nokia 502 is an unusual device
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/unusual_devs.h | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -226,6 +226,13 @@ UNUSUAL_DEV(  0x0421, 0x0495, 0x0370, 0x
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

