Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbaBHMrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 07:47:43 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33228 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaBHMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 07:47:11 -0500
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 2/2] ACPI / trivial: Fix the return value type of acpi_processor_eval_pdc()
Date: Sat,  8 Feb 2014 20:46:26 +0800
Message-Id: <1391863586-3157-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391863586-3157-1-git-send-email-hanjun.guo@linaro.org>
References: <1391863586-3157-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return value type of acpi_processor_eval_pdc() should be
'acpi_status' but defined as 'int', fix it.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/processor_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 849cfd6..46583d7 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -323,7 +323,7 @@ static struct acpi_object_list *acpi_processor_alloc_pdc(void)
  * _PDC is required for a BIOS-OS handshake for most of the newer
  * ACPI processor features.
  */
-static int
+static acpi_status
 acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
 {
 	acpi_status status = AE_OK;
-- 
1.7.9.5

