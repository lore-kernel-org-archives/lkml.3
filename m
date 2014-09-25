Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaIYPRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:17:18 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:36673 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaIYPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:17:16 -0400
Date: Thu, 25 Sep 2014 15:16:48 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Joe Perches <joe@perches.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>, Daniel Mack <daniel@caiaq.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] usb: core: log higher level message on malformed LANGID
 descriptor
Message-ID: <alpine.DEB.2.11.1409251515280.1779@localhost.localdomain>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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
index 0c8a7fc..f7b7713 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -770,9 +770,7 @@ static int usb_get_langid(struct usb_device *dev, unsigned char *tbuf)
  		dev->string_langid = 0x0409;
  		dev->have_langid = 1;
  		dev_err(&dev->dev,
-			"string descriptor 0 malformed (err = %d), "
-			"defaulting to 0x%04x\n",
-				err, dev->string_langid);
+			"language id specifier not provided by device, defaulting to English\n");
  		return 0;
  	}

-- 
2.1.0

