Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab3JCL0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:26:24 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:60765 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3JCL0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:26:20 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, grant.likely@secretlab.ca,
        roy.franz@linaro.org, msalter@redhat.com,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 3/3] init: efi: arm: enable (U)EFI runtime services on arm
Date: Thu,  3 Oct 2013 12:24:41 +0100
Message-Id: <1380799481-5470-4-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the efi_set_virtual_address_map call has strict init ordering
requirements, add an explicit hook in the required place.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 init/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/init/main.c b/init/main.c
index af310af..ec6d76e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -875,6 +875,10 @@ static noinline void __init kernel_init_freeable(void)
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
+
+	if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_BOOT))
+		efi_enter_virtual_mode();
+
 	lockup_detector_init();
 
 	smp_init();
-- 
1.7.10.4

