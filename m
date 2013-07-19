Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965845Ab3GSFaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:30:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965761Ab3GSF1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Jason Liu <r64343@freescale.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 63/72] ARM: 7778/1: smp_twd: twd_update_frequency need be run on all online CPUs
Date: Thu, 18 Jul 2013 22:26:20 -0700
Message-Id: <20130719052604.175456121@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Liu <r64343@freescale.com>

commit cbbe6f82b489e7ceba4ad7c833bd3a76cd0084cb upstream.

When the local timer freq changed, the twd_update_frequency function
should be run all the CPUs include itself, otherwise, the twd freq will
not get updated and the local timer will not run correcttly.

smp_call_function will run functions on all other CPUs, but not include
himself, this is not correct,use on_each_cpu instead to fix this issue.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Jason Liu <r64343@freescale.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/smp_twd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -120,7 +120,7 @@ static int twd_rate_change(struct notifi
 	 * changing cpu.
 	 */
 	if (flags == POST_RATE_CHANGE)
-		smp_call_function(twd_update_frequency,
+		on_each_cpu(twd_update_frequency,
 				  (void *)&cnd->new_rate, 1);
 
 	return NOTIFY_OK;


