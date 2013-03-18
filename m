Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132Ab3CRWBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:01:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3CRVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Williams <dcbw@redhat.com>
Subject: [ 16/75] qcserial: bind to DM/DIAG port on Gobi 1K devices
Date: Mon, 18 Mar 2013 14:06:39 -0700
Message-Id: <20130318210511.415262642@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dcbw@redhat.com>

commit 3f8bc5e4da29c7e05edeca6b475abb4fb01a5a13 upstream.

Turns out we just need altsetting 1 and then we can talk to it.

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/qcserial.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -197,12 +197,15 @@ static int qcprobe(struct usb_serial *se
 
 	if (is_gobi1k) {
 		/* Gobi 1K USB layout:
-		 * 0: serial port (doesn't respond)
+		 * 0: DM/DIAG (use libqcdm from ModemManager for communication)
 		 * 1: serial port (doesn't respond)
 		 * 2: AT-capable modem port
 		 * 3: QMI/net
 		 */
-		if (ifnum == 2)
+		if (ifnum == 0) {
+			dev_dbg(dev, "Gobi 1K DM/DIAG interface found\n");
+			altsetting = 1;
+		} else if (ifnum == 2)
 			dev_dbg(dev, "Modem port found\n");
 		else
 			altsetting = -1;


