Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbaDVU40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:56:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36475 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757524AbaDVUWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:22:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 070/133] usb: gadget: tcm_usb_gadget: stop format strings
Date: Tue, 22 Apr 2014 13:13:28 -0700
Message-Id: <1398197671-12786-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit aba37fd975f0dd58e025c99c2a79b61b20190831 upstream.

This makes sure that the name coming out of configfs cannot be used
accidentally as a format string.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/tcm_usb_gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 7cacd6a..e4d8d79 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1614,7 +1614,7 @@ static struct se_wwn *usbg_make_tport(
 		return ERR_PTR(-ENOMEM);
 	}
 	tport->tport_wwpn = wwpn;
-	snprintf(tport->tport_name, sizeof(tport->tport_name), wnn_name);
+	snprintf(tport->tport_name, sizeof(tport->tport_name), "%s", wnn_name);
 	return &tport->tport_wwn;
 }
 
-- 
1.9.1

