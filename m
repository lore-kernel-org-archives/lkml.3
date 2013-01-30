Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3A3Dte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:49:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44840 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3A3Dtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:49:32 -0500
Date: Tue, 29 Jan 2013 19:49:21 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-d1af6d045fba6b070fa81f54dfe9227214be99ea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-28-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-28-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, boot:
  Not need to check setup_header version for setup_data
Git-Commit-ID: d1af6d045fba6b070fa81f54dfe9227214be99ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 19:49:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1af6d045fba6b070fa81f54dfe9227214be99ea
Gitweb:     http://git.kernel.org/tip/d1af6d045fba6b070fa81f54dfe9227214be99ea
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:08 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 19:32:57 -0800

x86, boot: Not need to check setup_header version for setup_data

That is for bootloaders.

setup_data is in setup_header, and bootloader is copying that from bzImage.
So for old bootloader should keep that as 0 already.

old kexec-tools till now for elf image set setup_data to 0, so it is ok.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-28-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 519f2bc..b80bee1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -439,8 +439,6 @@ static void __init parse_setup_data(void)
 	struct setup_data *data;
 	u64 pa_data;
 
-	if (boot_params.hdr.version < 0x0209)
-		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		u32 data_len, map_len;
@@ -476,8 +474,6 @@ static void __init e820_reserve_setup_data(void)
 	u64 pa_data;
 	int found = 0;
 
-	if (boot_params.hdr.version < 0x0209)
-		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
@@ -501,8 +497,6 @@ static void __init memblock_x86_reserve_range_setup_data(void)
 	struct setup_data *data;
 	u64 pa_data;
 
-	if (boot_params.hdr.version < 0x0209)
-		return;
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
 		data = early_memremap(pa_data, sizeof(*data));
