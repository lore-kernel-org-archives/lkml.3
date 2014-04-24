Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaDXLOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:14:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46501 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbaDXIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/182] usb: gadget: tcm_usb_gadget: stop format strings
Date: Thu, 24 Apr 2014 09:49:41 +0100
Message-Id: <1398329507-5911-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit aba37fd975f0dd58e025c99c2a79b61b20190831 upstream.

This makes sure that the name coming out of configfs cannot be used
accidentally as a format string.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/tcm_usb_gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 0ff3339..d9e15e8 100644
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

