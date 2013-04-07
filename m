Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762464Ab3DGVLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 17:11:52 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:38060 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762164Ab3DGVLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 17:11:50 -0400
Date: Sun, 7 Apr 2013 14:11:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [patch -next] usb, gadget: use appropriate warning accessors
In-Reply-To: <515DCB78.3010207@infradead.org>
Message-ID: <alpine.DEB.2.02.1304071407520.3441@chino.kir.corp.google.com>
References: <20130404182232.bd2dbfba27620bdab9e0de42@canb.auug.org.au> <515DCB78.3010207@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the appropriate WARN() and WARN_ON() accessors to avoid a build error 
when CONFIG_BUG=n:

	drivers/usb/gadget/configfs.c: In function 'config_usb_cfg_unlink':
	drivers/usb/gadget/configfs.c:442:2: error: implicit declaration of function '__WARN_printf'
	drivers/usb/gadget/configfs.c: In function 'configfs_do_nothing':
	drivers/usb/gadget/configfs.c:733:2: error: implicit declaration of function '__WARN'

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -439,7 +439,7 @@ static int config_usb_cfg_unlink(
 		}
 	}
 	mutex_unlock(&gi->lock);
-	__WARN_printf("Unable to locate function to unbind\n");
+	WARN(1, "Unable to locate function to unbind\n");
 	return 0;
 }
 
@@ -730,7 +730,7 @@ USB_CONFIG_STRINGS_LANG(gadget_strings, gadget_info);
 
 static int configfs_do_nothing(struct usb_composite_dev *cdev)
 {
-	__WARN();
+	WARN_ON(1);
 	return -EINVAL;
 }
 
