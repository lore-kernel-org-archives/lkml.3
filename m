Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaLFWut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 17:50:49 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34083 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaLFWur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 17:50:47 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Rob Herring <robh+dt@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Vinod Koul <vinod.koul@intel.com>, Joel Fernandes <joelf@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH] arch: arm: common: edma.c:  Remove some unused functions
Date: Sat,  6 Dec 2014 23:53:26 +0100
Message-Id: <1417906406-5527-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
edma_shadow0_read() edma_or_array()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/common/edma.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index d86771a..163273d 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -160,10 +160,6 @@ static inline void edma_modify_array(unsigned ctlr, int offset, int i,
 {
 	edma_modify(ctlr, offset + (i << 2), and, or);
 }
-static inline void edma_or_array(unsigned ctlr, int offset, int i, unsigned or)
-{
-	edma_or(ctlr, offset + (i << 2), or);
-}
 static inline void edma_or_array2(unsigned ctlr, int offset, int i, int j,
 		unsigned or)
 {
@@ -174,10 +170,6 @@ static inline void edma_write_array2(unsigned ctlr, int offset, int i, int j,
 {
 	edma_write(ctlr, offset + ((i*2 + j) << 2), val);
 }
-static inline unsigned int edma_shadow0_read(unsigned ctlr, int offset)
-{
-	return edma_read(ctlr, EDMA_SHADOW0 + offset);
-}
 static inline unsigned int edma_shadow0_read_array(unsigned ctlr, int offset,
 		int i)
 {
-- 
1.7.10.4

