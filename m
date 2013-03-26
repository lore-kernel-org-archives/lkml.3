Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3CZWom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3CZWoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
        Michael Riesch <michael.riesch@omicron.at>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 96/98] usb: musb: da8xx: Fix build breakage due to typo
Date: Tue, 26 Mar 2013 15:43:25 -0700
Message-Id: <20130326224252.420503088@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>

commit db9e51617faad3a54d10b7cb340a82688ec0232d upstream.

Commit 032ec49f5351e9cb242b1a1c367d14415043ab95 (usb: musb: drop useless
board_mode usage) introduced a typo that breaks the build.

Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>

[ Fixed commit message ]

Signed-off-by: Michael Riesch <michael.riesch@omicron.at>
Cc: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/da8xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -327,7 +327,7 @@ static irqreturn_t da8xx_musb_interrupt(
 		u8 devctl = musb_readb(mregs, MUSB_DEVCTL);
 		int err;
 
-		err = musb->int_usb & USB_INTR_VBUSERROR;
+		err = musb->int_usb & MUSB_INTR_VBUSERROR;
 		if (err) {
 			/*
 			 * The Mentor core doesn't debounce VBUS as needed


