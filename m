Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaIKIhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:37:40 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:38550 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaIKIhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:37:34 -0400
From: Paul Burton <paul.burton@imgtec.com>
To: <linux-mips@linux-mips.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Burton <paul.burton@imgtec.com>
Subject: [PATCH 06/10] MIPS: ensure Config5.UFE is clear on boot
Date: Thu, 11 Sep 2014 08:30:19 +0100
Message-ID: <1410420623-11691-7-git-send-email-paul.burton@imgtec.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.159.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As is done for UFR, ensure that userland cannot directly manipulate the
mode by clearing the UFE bit during boot.

Signed-off-by: Paul Burton <paul.burton@imgtec.com>
---
 arch/mips/kernel/cpu-probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index db929a0..4e2a6e0 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -400,7 +400,7 @@ static inline unsigned int decode_config5(struct cpuinfo_mips *c)
 	unsigned int config5;
 
 	config5 = read_c0_config5();
-	config5 &= ~MIPS_CONF5_UFR;
+	config5 &= ~(MIPS_CONF5_UFR | MIPS_CONF5_UFE);
 	write_c0_config5(config5);
 
 	if (config5 & MIPS_CONF5_EVA)
-- 
2.0.4

