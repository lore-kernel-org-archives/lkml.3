Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbaIOVEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:04:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbaIOT07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, Marcel Witte <wittemar@googlemail.com>,
        Roger Tseng <rogerable@realtek.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 031/158] drivers/mfd/rtsx_usb.c: export device table
Date: Mon, 15 Sep 2014 12:24:30 -0700
Message-Id: <20140915192543.816848949@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@suse.com>

commit 1813908986e36119228c158aae1c6a0267c99e77 upstream.

The rtsx_usb driver contains the table for the devices it supports but
doesn't export it.  As a result, no alias is generated and it doesn't
get loaded automatically.

Via https://bugzilla.novell.com/show_bug.cgi?id=890096

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Reported-by: Marcel Witte <wittemar@googlemail.com>
Cc: Roger Tseng <rogerable@realtek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/rtsx_usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -744,6 +744,7 @@ static struct usb_device_id rtsx_usb_usb
 	{ USB_DEVICE(0x0BDA, 0x0140) },
 	{ }
 };
+MODULE_DEVICE_TABLE(usb, rtsx_usb_usb_ids);
 
 static struct usb_driver rtsx_usb_driver = {
 	.name			= "rtsx_usb",


