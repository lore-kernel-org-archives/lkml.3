Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbaIBWNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:13:38 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47428 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755605AbaIBWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:13:36 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 10/26] serial: core: Document lock requirement for UPF_* flags updates
Date: Tue,  2 Sep 2014 17:39:19 -0400
Message-Id: <1409693975-1028-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flags field of struct uart_port can only be safely modified
if the port mutex is held; no other lock prevents concurrent
changes from corrupting the field.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/serial_core.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 5bbb809..4a43292 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -152,6 +152,7 @@ struct uart_port {
 	unsigned long		sysrq;			/* sysrq timeout */
 #endif
 
+	/* flags must be updated while holding port mutex */
 	upf_t			flags;
 
 #define UPF_FOURPORT		((__force upf_t) (1 << 1))
-- 
2.1.0

