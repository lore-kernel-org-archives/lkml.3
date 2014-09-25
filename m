Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaIYN5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:57:16 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:50154 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbaIYN5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:57:14 -0400
Date: Thu, 25 Sep 2014 13:56:37 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
cc: Daniel Mack <daniel@caiaq.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: core: log higher level message on malformed LANGID
 descriptor
Message-ID: <alpine.DEB.2.11.1409251356120.1920@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0cce2eda19923e5e5ccc8b042dec5af87b3ffad0
    USB: fix LANGID=0 regression

defaults to a langid of 0x0409 if it's not properly implemented by the
device. Explain with a higher level error message what this means.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
---
 drivers/usb/core/message.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 0c8a7fc..5317081 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -770,9 +770,7 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
 		dev->string_langid = 0x0409;
 		dev->have_langid = 1;
 		dev_err(&dev->dev,
-			"string descriptor 0 malformed (err = %d), "
-			"defaulting to 0x%04x\n",
-				err, dev->string_langid);
+			"language id specifier not provided by device, defaulting to English");
 		return 0;
 	}

-- 
2.1.0

