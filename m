Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbaEDQib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:38:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbaEDPlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3.14 103/158] usb: gadget: tcm_usb_gadget: stop format strings
Date: Sun,  4 May 2014 11:40:12 -0400
Message-Id: <20140504154043.948441427@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit aba37fd975f0dd58e025c99c2a79b61b20190831 upstream.

This makes sure that the name coming out of configfs cannot be used
accidentally as a format string.

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/tcm_usb_gadget.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
 


