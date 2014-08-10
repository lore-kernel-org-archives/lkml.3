Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaHJHbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:31:18 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50966 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHJHbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:31:17 -0400
Date: Sun, 10 Aug 2014 09:31:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Miguel Oliveira <cmroliv@gmail.com>, gulsah.1004@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] staging: nokia_h4: avoid __uX types
Message-ID: <20140810073115.GB19735@amd.pavel.ucw.cz>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
 <20140530123023.GA10549@amd.pavel.ucw.cz>
 <20140530155959.GA10682@kroah.com>
 <201405301815.10811@pali>
 <20140530163604.GA11943@kroah.com>
 <DB71A450-EF1D-479F-9111-A36FF8EA89B2@holtmann.org>
 <20140806213055.GA26046@amd.pavel.ucw.cz>
 <20140807002532.GB23406@kroah.com>
 <20140807081328.GB24700@amd.pavel.ucw.cz>
 <20140807202407.GC6060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807202407.GC6060@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__u8/16 types should not be neccessary inside kernel, u8/16 should
be enough.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/staging/nokia_h4p/hci_h4p.h b/drivers/staging/nokia_h4p/hci_h4p.h
index 76eaaaa..b91e8b3 100644
--- a/drivers/staging/nokia_h4p/hci_h4p.h
+++ b/drivers/staging/nokia_h4p/hci_h4p.h
@@ -100,12 +100,12 @@ struct hci_h4p_info {
 };
 
 struct hci_h4p_radio_hdr {
-	__u8 evt;
-	__u8 dlen;
+	u8 evt;
+	u8 dlen;
 } __packed;
 
 struct hci_h4p_neg_hdr {
-	__u8 dlen;
+	u8 dlen;
 } __packed;
 #define H4P_NEG_HDR_SIZE 1
 
@@ -121,36 +121,36 @@ struct hci_h4p_neg_hdr {
 #define H4P_ID_TI1271	0x31
 
 struct hci_h4p_neg_cmd {
-	__u8	ack;
-	__u16	baud;
-	__u16	unused1;
-	__u8	proto;
-	__u16	sys_clk;
-	__u16	unused2;
+	u8	ack;
+	u16	baud;
+	u16	unused1;
+	u8	proto;
+	u16	sys_clk;
+	u16	unused2;
 } __packed;
 
 struct hci_h4p_neg_evt {
-	__u8	ack;
-	__u16	baud;
-	__u16	unused1;
-	__u8	proto;
-	__u16	sys_clk;
-	__u16	unused2;
-	__u8	man_id;
-	__u8	ver_id;
+	u8	ack;
+	u16	baud;
+	u16	unused1;
+	u8	proto;
+	u16	sys_clk;
+	u16	unused2;
+	u8	man_id;
+	u8	ver_id;
 } __packed;
 
 #define H4P_ALIVE_REQ	0x55
 #define H4P_ALIVE_RESP	0xcc
 
 struct hci_h4p_alive_hdr {
-	__u8	dlen;
+	u8	dlen;
 } __packed;
 #define H4P_ALIVE_HDR_SIZE 1
 
 struct hci_h4p_alive_pkt {
-	__u8	mid;
-	__u8	unused;
+	u8	mid;
+	u8	unused;
 } __packed;
 
 #define MAX_BAUD_RATE		921600

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
