Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3EUPJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:09:52 -0400
Received: from 17.mo4.mail-out.ovh.net ([46.105.41.16]:54423 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751364Ab3EUPJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:09:51 -0400
X-Greylist: delayed 8410 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 May 2013 11:09:51 EDT
Message-ID: <519B5B13.1020807@ventoso.org>
Date: Tue, 21 May 2013 13:31:31 +0200
From: Luca Olivetti <luca@ventoso.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: msroczyn@gmail.com, schaefer.frank@gmx.net, Greg KH <gregkh@suse.de>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH] pl2303 works at 500kbps
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6574129557906360637
X-Ovh-Remote: 85.52.14.39 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeigedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeigedrtddtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My PL2303HX works at 500kbps after applying this patch.
I suppose that it could work at other non standard speeds since this fix

"correctly handle baudrates above 115200"
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/usb/serial/pl2303.c?id=8d48fdf689fed2c73c493e5146d1463689246442

came after this one

"fix baud rate handling in case of unsupported values"
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/usb/serial/pl2303.c?id=25b8286805e856c8c7fda127018e31032c918015

but I only can test it with 500000.
Patch made against mainline but tested with 3.4.45

Please CC me since I'm not subscribed

Signed-off-by: Luca Olivetti <luca@ventoso.org>
---
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 7151659..ca19b17 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -275,7 +275,7 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	u8 control;
 	const int baud_sup[] = { 75, 150, 300, 600, 1200, 1800, 2400, 3600,
 	                         4800, 7200, 9600, 14400, 19200, 28800, 38400,
-	                         57600, 115200, 230400, 460800, 614400,
+	                         57600, 115200, 230400, 460800, 500000, 614400,
 	                         921600, 1228800, 2457600, 3000000, 6000000 };
 	int baud_floor, baud_ceil;
 	int k;
