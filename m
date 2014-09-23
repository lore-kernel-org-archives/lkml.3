Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaIWW33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:29:29 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:39208 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbaIWW32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:29:28 -0400
Date: Tue, 23 Sep 2014 22:28:49 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
cc: Daniel Mack <daniel@caiaq.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] usb: core: log more general message on malformed LANGID
 descriptor
Message-ID: <alpine.DEB.2.11.1409232013320.2145@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to change this error message:
[    3.325837] usb 1-4: string descriptor 0 malformed (err = -61), defaulting to 0x0409

into an error message followed by a debug message:
[    3.324726] usb 1-4: malformed string descriptor; unknown language, defaulting to English
[    3.327514] usb 1-4: string descriptor 0 malformed (err = -61), defaulting to 0x0409

in order to communicate more information from the log itself. Are there 
any problems with this approach? Would it be better to put all the 
information on a single line? Something else?


---
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 0c8a7fc..c29eb37 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -770,6 +770,8 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
 		dev->string_langid = 0x0409;
 		dev->have_langid = 1;
 		dev_err(&dev->dev,
+			"malformed string descriptor; unknown language, defaulting to English");
+		dev_dbg(&dev->dev,
 			"string descriptor 0 malformed (err = %d), "
 			"defaulting to 0x%04x\n",
 				err, dev->string_langid);
