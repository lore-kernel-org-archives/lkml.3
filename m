Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3J1Duu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 23:50:50 -0400
Received: from intranet.asianux.com ([58.214.24.6]:64802 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3J1Dut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 23:50:49 -0400
X-Spam-Score: -100.8
Message-ID: <526DDEDB.4030503@asianux.com>
Date: Mon, 28 Oct 2013 11:49:47 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "vgupta@synopsys.com" <vgupta@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arc: kernel: export symbol for pm_power_off in reset.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need export symbol for it, or can not pass compiling, the related error
with allmodconfig: 

    MODPOST 2994 modules
  ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
  ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/arc/kernel/reset.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arc/kernel/reset.c b/arch/arc/kernel/reset.c
index e227a2b..2768fa1 100644
--- a/arch/arc/kernel/reset.c
+++ b/arch/arc/kernel/reset.c
@@ -31,3 +31,4 @@ void machine_power_off(void)
 }
 
 void (*pm_power_off) (void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
-- 
1.7.7.6
