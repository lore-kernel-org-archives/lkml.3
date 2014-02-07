Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaBGLtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:49:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaBGLtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:22 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Woithe <jwoithe@just42.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 067/233] serial: 8250: Fix initialisation of Quatech cards with the AMCC PCI chip
Date: Fri,  7 Feb 2014 11:44:46 +0000
Message-Id: <1391773652-25214-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Woithe <jwoithe@just42.net>

commit 9c5320f8d7d9a2cf623e65d50e1113f34d9b9eb1 upstream.

Fix the initialisation of older Quatech serial cards which are fitted with
the AMCC PCI Matchmaker interface chip.

Signed-off-by: Jonathan Woithe (jwoithe@just42.net)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/tty/serial/8250/8250_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index c52948b..1431e0a 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1260,10 +1260,10 @@ static int pci_quatech_init(struct pci_dev *dev)
 		unsigned long base = pci_resource_start(dev, 0);
 		if (base) {
 			u32 tmp;
-			outl(inl(base + 0x38), base + 0x38);
+			outl(inl(base + 0x38) | 0x00002000, base + 0x38);
 			tmp = inl(base + 0x3c);
 			outl(tmp | 0x01000000, base + 0x3c);
-			outl(tmp, base + 0x3c);
+			outl(tmp &= ~0x01000000, base + 0x3c);
 		}
 	}
 	return 0;
-- 
1.8.3.2

