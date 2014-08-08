Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319AbaHHVb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:31:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255AbaHHVby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:31:54 -0400
Message-ID: <53E541C7.9030407@suse.com>
Date: Fri, 08 Aug 2014 17:31:51 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Roger Tseng <rogerable@realtek.com>, akpm <akpm@linux-foundation.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtsx_usb: export device table
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rtsx_usb driver contains the table for the devices it supports but
doesn't export it. As a result, no alias is generated and it doesn't
get loaded automatically.

Via https://bugzilla.novell.com/show_bug.cgi?id=890096

Reported-by: Marcel Witte <wittemar@googlemail.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
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


-- 
Jeff Mahoney
SUSE Labs
