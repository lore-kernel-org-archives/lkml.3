Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3LDJ3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:29:44 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59916 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3LDJ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:29:41 -0500
From: dt.tangr@gmail.com
To: trivial@kernel.org
Cc: Daniel Tang <dt.tangr@gmail.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 2/2] arm: nspire: fix compile-time warnings
Date: Wed,  4 Dec 2013 20:29:11 +1100
Message-Id: <1386149351-15269-2-git-send-email-dt.tangr@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386149351-15269-1-git-send-email-dt.tangr@gmail.com>
References: <1386149351-15269-1-git-send-email-dt.tangr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Tang <dt.tangr@gmail.com>

Fix nspire_restart to take enum reboot_mode instead of a char so the 
correct function pointer is passed to DT_MACHINE_START.


Signed-off-by: Daniel Tang <dt.tangr@gmail.com>
---
 arch/arm/mach-nspire/nspire.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-nspire/nspire.c b/arch/arm/mach-nspire/nspire.c
index 4b2ed2e..3d24ebf 100644
--- a/arch/arm/mach-nspire/nspire.c
+++ b/arch/arm/mach-nspire/nspire.c
@@ -63,7 +63,7 @@ static void __init nspire_init(void)
 			nspire_auxdata, NULL);
 }

-static void nspire_restart(char mode, const char *cmd)
+static void nspire_restart(enum reboot_mode mode, const char *cmd)
 {
 	void __iomem *base = ioremap(NSPIRE_MISC_PHYS_BASE, SZ_4K);
 	if (!base)
--
1.8.1.3

