Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab3ENPjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:39:32 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48569 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab3ENPj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:39:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jamie Iles <jamie@jamieiles.com>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Christian Daudt <csd@broadcom.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Barry Song <baohua.song@csr.com>,
        Tony Prisk <linux@prisktech.co.nz>
Cc: linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: [PATCH 19/20] ARM: virt: Remove init_irq declaration in machine description
Date: Tue, 14 May 2013 17:38:52 +0200
Message-Id: <1368545933-7430-20-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368545933-7430-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ebafed7a ("ARM: irq: Call irqchip_init if no init_irq function is
specified") removed the need to explictly setup the init_irq field in
the machine description when using only irqchip_init. Remove that
declaration for virt as well.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-virt/virt.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/mach-virt/virt.c b/arch/arm/mach-virt/virt.c
index 061f283..bdf05f4 100644
--- a/arch/arm/mach-virt/virt.c
+++ b/arch/arm/mach-virt/virt.c
@@ -18,7 +18,6 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <linux/irqchip.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/smp.h>
@@ -39,7 +38,6 @@ static const char *virt_dt_match[] = {
 extern struct smp_operations virt_smp_ops;
 
 DT_MACHINE_START(VIRT, "Dummy Virtual Machine")
-	.init_irq	= irqchip_init,
 	.init_machine	= virt_init,
 	.smp		= smp_ops(virt_smp_ops),
 	.dt_compat	= virt_dt_match,
-- 
1.8.1.2

