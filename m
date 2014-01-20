Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaATThb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:37:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaATTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:37:27 -0500
Date: Mon, 20 Jan 2014 19:37:16 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Ian Munsie <imunsie@au1.ibm.com>,
        Tony Breeds <tony@bakeyournoodle.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: Fix build dependencies for ep88xc
Message-ID: <20140120193709.GA5084@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a build failure that seems to be present since commit

commit b81f18e55e9f4ea81759bcb00fea295de679bbe8
Author: Tony Breeds <tony@bakeyournoodle.com>
Date:   Tue Apr 3 15:00:39 2012 +0000

    powerpc/boot: Only build board support files when required.

This is easily reproducible my using the ep88xc_defconfig config file:

arch/powerpc/boot/wrapper.a(mpc8xx.o): In function `mpc885_get_clock':
/home/henrix/src/linux/arch/powerpc/boot/mpc8xx.c:30: undefined reference to `fsl_get_immr'
make[1]: *** [arch/powerpc/boot/dtbImage.ep88xc] Error 1

Fixes: b81f18e55e9f ("powerpc/boot: Only build board support files when required.")
Cc: Tony Breeds <tony@bakeyournoodle.com>
Cc: <stable@vger.kernel.org> (3.6+)
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/boot/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index ca7f08c..981d418 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -71,7 +71,7 @@ src-wlib-y := string.S crt0.S crtsavres.S stdio.c main.c \
 		uartlite.c mpc52xx-psc.c
 src-wlib-$(CONFIG_40x) += 4xx.c planetcore.c
 src-wlib-$(CONFIG_44x) += 4xx.c ebony.c bamboo.c
-src-wlib-$(CONFIG_8xx) += mpc8xx.c planetcore.c
+src-wlib-$(CONFIG_8xx) += mpc8xx.c fsl-soc.c planetcore.c
 src-wlib-$(CONFIG_PPC_82xx) += pq2.c fsl-soc.c planetcore.c
 src-wlib-$(CONFIG_EMBEDDED6xx) += mv64x60.c mv64x60_i2c.c ugecon.c
 
-- 
1.8.3.2

Cheers,
--
Luis
