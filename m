Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab3EMKQS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:16:18 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41889 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3EMKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:16:15 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/4] ARM: mmu: Call debug_ll_io_init if no map_io function is specified
Date: Mon, 13 May 2013 12:16:06 +0200
Message-Id: <1368440169-29088-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More and more sub-architectures are using only the debug_ll_io_init
function as the map_io function. Make the core code call this function
if no function is specified in the machine description to remove some
boilerplate code.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mm/mmu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e0d8565..faa36d7 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1232,6 +1232,8 @@ static void __init devicemaps_init(struct machine_desc *mdesc)
 	 */
 	if (mdesc->map_io)
 		mdesc->map_io();
+	else
+		debug_ll_io_init();
 	fill_pmd_gaps();
 
 	/* Reserve fixed i/o space in VMALLOC region */
-- 
1.8.1.2

