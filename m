Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3ETGs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:48:56 -0400
Received: from intranet.asianux.com ([58.214.24.6]:7627 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3ETGsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:48:55 -0400
X-Spam-Score: -100.8
Message-ID: <5199C725.8050102@asianux.com>
Date: Mon, 20 May 2013 14:48:05 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>, marc.zyngier@arm.com,
        Tony Lindgren <tony@atomide.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm64: kernel: compiling issue, need 'EXPORT_SYMBOL_GPL(read_current_timer)'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Need 'EXPORT_SYMBOL_GPL(read_current_timer)' if build with allmodconfig.

The related error:
  ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
  ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
  ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
  ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arm64/kernel/time.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index a551f88..7fcba80 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -73,6 +73,7 @@ int read_current_timer(unsigned long *timer_value)
 	*timer_value = arch_timer_read_counter();
 	return 0;
 }
+EXPORT_SYMBOL_GPL(read_current_timer);
 
 void __init time_init(void)
 {
-- 
1.7.7.6
