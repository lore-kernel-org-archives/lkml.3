Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbaEMJ4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:56:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60843 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760083AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 080/182] usb: gadget: tcm_usb_gadget: stop format strings
Date: Tue, 13 May 2014 11:27:12 +0200
Message-Id: <37bac6ddf2c54d7ceeff9f36d90bd2524db26457.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit aba37fd975f0dd58e025c99c2a79b61b20190831 upstream.

This makes sure that the name coming out of configfs cannot be used
accidentally as a format string.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/gadget/tcm_usb_gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 0ff33396eef3..d9e15e85258d 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1613,7 +1613,7 @@ static struct se_wwn *usbg_make_tport(
 		return ERR_PTR(-ENOMEM);
 	}
 	tport->tport_wwpn = wwpn;
-	snprintf(tport->tport_name, sizeof(tport->tport_name), wnn_name);
+	snprintf(tport->tport_name, sizeof(tport->tport_name), "%s", wnn_name);
 	return &tport->tport_wwn;
 }
 
-- 
1.9.3

