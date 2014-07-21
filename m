Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbaGUOsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 10:48:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45833 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaGUOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 10:48:31 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Marek Vasut <marex@denx.de>, Harro Haan <hrhaan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH RFC 4/9] ARM: dump the status of NS bit in L1 PTE
Date: Mon, 21 Jul 2014 15:47:15 +0100
Message-Id: <1405954040-30399-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
References: <1405954040-30399-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Vasut <marex@denx.de>

Add minor adjustment to the page table dumper to also print the status
of the L1 PTE NS bit.

Signed-off-by: Marek Vasut <marex@denx.de>
---
 arch/arm/mm/dump.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index c508f41..0100edb 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -176,6 +176,11 @@ static const struct prot_bits section_bits[] = {
 		.val	= PMD_SECT_S,
 		.set	= "SHD",
 		.clear	= "   ",
+	}, {
+		.mask	= PMD_SECT_NS,
+		.val	= PMD_SECT_NS,
+		.set	= "NS ",
+		.clear	= "ns ",
 	},
 };
 
-- 
1.9.3

