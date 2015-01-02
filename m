Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbbABU7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:59:43 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:38418 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbbABU7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:59:42 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: ohci:  Remove unused function
Date: Fri,  2 Jan 2015 22:02:43 +0100
Message-Id: <1420232563-3464-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function ar_prev_buffer_index() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/firewire/ohci.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index a66a321..9662daa 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -719,11 +719,6 @@ static inline unsigned int ar_next_buffer_index(unsigned int index)
 	return (index + 1) % AR_BUFFERS;
 }
 
-static inline unsigned int ar_prev_buffer_index(unsigned int index)
-{
-	return (index - 1 + AR_BUFFERS) % AR_BUFFERS;
-}
-
 static inline unsigned int ar_first_buffer_index(struct ar_context *ctx)
 {
 	return ar_next_buffer_index(ctx->last_buffer_index);
-- 
1.7.10.4

