Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaAHPn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:43:58 -0500
Received: from atlantis.wh2.tu-dresden.de ([141.30.228.39]:56981 "EHLO
	atlantis.wh2.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301AbaAHPnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:43:55 -0500
From: Lars Poeschel <larsi@wh2.tu-dresden.de>
To: poeschel@lemonage.de, rob@landley.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: [PATCH] n_gsm/documentation: Add some words about DCD signal
Date: Wed,  8 Jan 2014 16:42:55 +0100
Message-Id: <1389195775-22959-1-git-send-email-larsi@wh2.tu-dresden.de>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Poeschel <poeschel@lemonage.de>

Add some words about modem control lines, DCD signal and that
an open may block to the n_gsm documentation.

Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
---
 Documentation/serial/n_gsm.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/serial/n_gsm.txt b/Documentation/serial/n_gsm.txt
index a5d9112..089b934 100644
--- a/Documentation/serial/n_gsm.txt
+++ b/Documentation/serial/n_gsm.txt
@@ -74,6 +74,12 @@ done
 for example, it's possible :
 - and to use gnokii to send / receive SMS on ttygsm1
 - to use ppp to establish a datalink on ttygsm2
+- If you want to use a virtual muxed channel in your own programs, be aware
+  that it respects the modem control lines. If you open the virtual port it
+  will block, if it is not connected to a carrier (DCD signal missing). You
+  could open the virtual port with O_NDELAY flag and do normal AT commands
+  to the modem without a carrier. You can change to blocking mode later if
+  you need this with fcntl F_SETFL/F_GETFL.
 
 6- first close all virtual ports before closing the physical port.
 
-- 
1.8.5.2

