Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498AbaE0AE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 20:04:29 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:62972 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaE0AE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 20:04:28 -0400
Message-ID: <5383D688.3080900@gmail.com>
Date: Tue, 27 May 2014 08:04:24 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Guan Xuetao <gxt@mprc.pku.edu.cn>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] arch: unicore32: ksyms: export 'pm_power_off' to avoid
 compiling failure.
References: <5383D5F5.2000303@gmail.com>
In-Reply-To: <5383D5F5.2000303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two driver modules need 'pm_power_off', so export it.

The related error (with allmodconfig under unicore32):

    MODPOST 4039 modules
  ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
  ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/unicore32/kernel/process.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 778ebba..b008e99 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -60,6 +60,7 @@ void machine_halt(void)
  * Function pointers to optional machine specific functions
  */
 void (*pm_power_off)(void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
 
 void machine_power_off(void)
 {
-- 
1.9.2.459.g68773ac
