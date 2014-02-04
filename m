Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935101AbaBDVWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:22:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935074AbaBDVWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:22:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonathan Woithe <jwoithe@just42.net>
Subject: [PATCH 3.13 066/140] serial: 8250: Fix initialisation of Quatech cards with the AMCC PCI chip
Date: Tue,  4 Feb 2014 13:10:53 -0800
Message-Id: <20140204211038.842788973@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Woithe <jwoithe@just42.net>

commit 9c5320f8d7d9a2cf623e65d50e1113f34d9b9eb1 upstream.

Fix the initialisation of older Quatech serial cards which are fitted with
the AMCC PCI Matchmaker interface chip.

Signed-off-by: Jonathan Woithe (jwoithe@just42.net)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1259,10 +1259,10 @@ static int pci_quatech_init(struct pci_d
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


