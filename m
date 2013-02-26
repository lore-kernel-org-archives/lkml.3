Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905Ab3BZAYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:24:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35741 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759707Ab3BZAYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:24:06 -0500
Date: Mon, 25 Feb 2013 16:22:48 -0800
From: tip-bot for Matt Fleming <tipbot@zytor.com>
Message-ID: <tip-058e7b5814534461b0e2468fce5a8f8d2f43c38f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, matt.fleming@intel.com,
        takeuchi_satoru@jp.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, matt.fleming@intel.com,
        takeuchi_satoru@jp.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1361545427-26393-1-git-send-email-matt@console-pimps.org>
References: <1361545427-26393-1-git-send-email-matt@console-pimps.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi: Mark disable_runtime as __initdata
Git-Commit-ID: 058e7b5814534461b0e2468fce5a8f8d2f43c38f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 25 Feb 2013 16:22:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  058e7b5814534461b0e2468fce5a8f8d2f43c38f
Gitweb:     http://git.kernel.org/tip/058e7b5814534461b0e2468fce5a8f8d2f43c38f
Author:     Matt Fleming <matt.fleming@intel.com>
AuthorDate: Fri, 22 Feb 2013 15:03:47 +0000
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 25 Feb 2013 16:01:35 -0800

x86, efi: Mark disable_runtime as __initdata

disable_runtime is only referenced from __init functions, so mark it
as __initdata.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/1361545427-26393-1-git-send-email-matt@console-pimps.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e2cd38f..ec9f325 100644
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
