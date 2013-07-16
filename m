Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab3GPRFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:05:47 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:35593 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933501Ab3GPRF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:05:28 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [PATCH 7/7] alpha: Fix type compatibility warning for marvel_map_irq
Date: Tue, 16 Jul 2013 10:04:40 -0700
Message-Id: <1373994280-12047-8-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373994280-12047-1-git-send-email-rth@twiddle.net>
References: <1373994280-12047-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/kernel/sys_marvel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 407accc..53d6e4a 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -317,8 +317,9 @@ marvel_init_irq(void)
 }
 
 static int 
-marvel_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
+marvel_map_irq(const struct pci_dev *cdev, u8 slot, u8 pin)
 {
+	struct pci_dev *dev = (struct pci_dev *)dev;
 	struct pci_controller *hose = dev->sysdata;
 	struct io7_port *io7_port = hose->sysdata;
 	struct io7 *io7 = io7_port->io7;
-- 
1.8.1.4

