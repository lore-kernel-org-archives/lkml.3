Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3K2D7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 22:59:30 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47146 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3K2D70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 22:59:26 -0500
Message-ID: <529811A1.3030708@gmail.com>
Date: Fri, 29 Nov 2013 12:01:37 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: hexagon: kernel: reset.c: use function pointer instead
 of function for pm_power_off and export it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'pm_power_off' is a function pointer, not a function, so need change
its type, and also need export it, or can not pass compiling with
allmodconfig. The related error:

    MODPOST 2879 modules
  ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/hexagon/kernel/reset.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/hexagon/kernel/reset.c b/arch/hexagon/kernel/reset.c
index 6aeabc9..76483c1 100644
--- a/arch/hexagon/kernel/reset.c
+++ b/arch/hexagon/kernel/reset.c
@@ -33,6 +33,5 @@ void machine_restart(char *cmd)
 {
 }
 
-void pm_power_off(void)
-{
-}
+void (*pm_power_off)(void) = NULL;
+EXPORT_SYMBOL(pm_power_off);
-- 
1.7.7.6
