Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab3BVPD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 10:03:56 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:47318 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558Ab3BVPDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 10:03:55 -0500
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: [PATCH] x86, efi: Mark disable_runtime as __initdata
Date: Fri, 22 Feb 2013 15:03:47 +0000
Message-Id: <1361545427-26393-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

disable_runtime is only referenced from __init functions, so mark it
as __initdata.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/platform/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 2f81db4..5ae99f9 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -85,7 +85,7 @@ int efi_enabled(int facility)
 }
 EXPORT_SYMBOL(efi_enabled);
 
-static bool disable_runtime = false;
+static bool __initdata disable_runtime = false;
 static int __init setup_noefi(char *arg)
 {
 	disable_runtime = true;
-- 
1.7.11.7

