Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3CRVGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:06:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab3CRVGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>
Subject: [ 23/75] tty: serial: fix typo "SERIAL_S3C2412"
Date: Mon, 18 Mar 2013 14:06:46 -0700
Message-Id: <20130318210511.908272377@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Bolle <pebolle@tiscali.nl>

commit c51d41a1dd8f23a06a4ed651ebb9617de7f59368 upstream.

The Kconfig symbol SERIAL_S3C2412 got removed in commit
da121506eb03ee5daea55404709110b798bd61d9 ("serial: samsung: merge
probe() function from all SoC specific extensions"). But it also added a
last reference to that symbol. The commit and the tree make clear that
CPU_S3C2412 should have been used instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -209,7 +209,7 @@ config SERIAL_SAMSUNG
 config SERIAL_SAMSUNG_UARTS_4
 	bool
 	depends on PLAT_SAMSUNG
-	default y if !(CPU_S3C2410 || SERIAL_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
+	default y if !(CPU_S3C2410 || CPU_S3C2412 || CPU_S3C2440 || CPU_S3C2442)
 	help
 	  Internal node for the common case of 4 Samsung compatible UARTs
 


