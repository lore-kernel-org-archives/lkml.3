Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbbAAQns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 11:43:48 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58385 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbbAAQnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 11:43:47 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] misc: sgi-gru: gruhandles.c:  Remove unused function
Date: Thu,  1 Jan 2015 17:46:47 +0100
Message-Id: <1420130807-29468-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function tfh_restart() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/misc/sgi-gru/gruhandles.c |    6 ------
 drivers/misc/sgi-gru/gruhandles.h |    1 -
 2 files changed, 7 deletions(-)

diff --git a/drivers/misc/sgi-gru/gruhandles.c b/drivers/misc/sgi-gru/gruhandles.c
index 2f30bad..1ee8e82 100644
--- a/drivers/misc/sgi-gru/gruhandles.c
+++ b/drivers/misc/sgi-gru/gruhandles.c
@@ -196,12 +196,6 @@ void tfh_write_restart(struct gru_tlb_fault_handle *tfh,
 	start_instruction(tfh);
 }
 
-void tfh_restart(struct gru_tlb_fault_handle *tfh)
-{
-	tfh->opc = TFHOP_RESTART;
-	start_instruction(tfh);
-}
-
 void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh)
 {
 	tfh->opc = TFHOP_USER_POLLING_MODE;
diff --git a/drivers/misc/sgi-gru/gruhandles.h b/drivers/misc/sgi-gru/gruhandles.h
index 3f998b9..3d7bd36 100644
--- a/drivers/misc/sgi-gru/gruhandles.h
+++ b/drivers/misc/sgi-gru/gruhandles.h
@@ -524,7 +524,6 @@ int tfh_write_only(struct gru_tlb_fault_handle *tfh, unsigned long paddr,
 	int gaa, unsigned long vaddr, int asid, int dirty, int pagesize);
 void tfh_write_restart(struct gru_tlb_fault_handle *tfh, unsigned long paddr,
 	int gaa, unsigned long vaddr, int asid, int dirty, int pagesize);
-void tfh_restart(struct gru_tlb_fault_handle *tfh);
 void tfh_user_polling_mode(struct gru_tlb_fault_handle *tfh);
 void tfh_exception(struct gru_tlb_fault_handle *tfh);
 
-- 
1.7.10.4

