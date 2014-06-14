Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaFNQYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 12:24:21 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35039 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaFNQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 12:24:16 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: powerpc: platforms: cell: cbe_thermal.c:  Cleaning up a variable is of the wrong type
Date: Sat, 14 Jun 2014 18:25:11 +0200
Message-Id: <1402763111-23458-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402763111-23458-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1402763111-23458-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variable is of the wrong type, everywhere it is used it
should be an unsigned int rather than a int.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/powerpc/platforms/cell/cbe_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/cell/cbe_thermal.c b/arch/powerpc/platforms/cell/cbe_thermal.c
index 94560db..2c15ff0 100644
--- a/arch/powerpc/platforms/cell/cbe_thermal.c
+++ b/arch/powerpc/platforms/cell/cbe_thermal.c
@@ -125,7 +125,7 @@ static ssize_t show_throttle(struct cbe_pmd_regs __iomem *pmd_regs, char *buf, i
 static ssize_t store_throttle(struct cbe_pmd_regs __iomem *pmd_regs, const char *buf, size_t size, int pos)
 {
 	u64 reg_value;
-	int temp;
+	unsigned int temp;
 	u64 new_value;
 	int ret;
 
-- 
1.7.10.4

