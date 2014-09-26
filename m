Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbaIZK17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:27:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbaIZJqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/142] usb: host: ohci-spear: fix ohci_dump parameters
Date: Fri, 26 Sep 2014 11:43:33 +0200
Message-Id: <d8804ba0670cf260cce15f9d98bb2f0b668c0a81.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vincent Stehlé <vincent.stehle@laposte.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

Commit 6a04d05acfb51355 ("USB: OHCI: fix bugs in debug routines") has removed
the unused `verbose' argument of the debug function ohci_dump(); adapt
ohci-spear accordingly.

This fixes the following compilation error:

  drivers/usb/host/ohci-spear.c: In function ‘ohci_spear_start’:
  drivers/usb/host/ohci-spear.c:56:2: error: too many arguments to function ‘ohci_dump’

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/ohci-spear.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
index cc9dd9e4f05e..45f87735b449 100644
--- a/drivers/usb/host/ohci-spear.c
+++ b/drivers/usb/host/ohci-spear.c
@@ -53,7 +53,7 @@ static int ohci_spear_start(struct usb_hcd *hcd)
 	create_debug_files(ohci);
 
 #ifdef DEBUG
-	ohci_dump(ohci, 1);
+	ohci_dump(ohci);
 #endif
 	return 0;
 }
-- 
2.1.0

