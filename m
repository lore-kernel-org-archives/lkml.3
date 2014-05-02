Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaEBQEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:04:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaEBPn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/151] usb: gadget: tcm_usb_gadget: stop format strings
Date: Fri,  2 May 2014 08:37:21 -0700
Message-Id: <1399045139-4531-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
index 0f8aad7..460c266 100644
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
1.9.1

