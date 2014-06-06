Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaFFXYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:24:38 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35837 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbaFFXYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:24:36 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Karsten Keil <isdn@linux-pingi.de>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: mISDN: dsp_cmx.c:  Cleaning up a define that is no longer available
Date: Sat,  7 Jun 2014 01:25:30 +0200
Message-Id: <1402097131-10954-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes an ifdef that is no longer available,
and that would cause a compile error if it was activated.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/isdn/mISDN/dsp_cmx.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_cmx.c b/drivers/isdn/mISDN/dsp_cmx.c
index a4f05c5..9e9bdc0 100644
--- a/drivers/isdn/mISDN/dsp_cmx.c
+++ b/drivers/isdn/mISDN/dsp_cmx.c
@@ -1511,9 +1511,6 @@ dsp_cmx_send_member(struct dsp *dsp, int len, s32 *c, int members)
 			dsp->tx_R = t;
 			goto send_packet;
 		}
-#ifdef DSP_NEVER_DEFINED
-	}
-#endif
 	/* PROCESS DATA (three or more members) */
 	/* -> if echo is NOT enabled */
 	if (!dsp->echo.software) {
-- 
1.7.10.4

