Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab3CLKNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:13:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3926 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3CLKNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:13:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 12 Mar 2013 03:07:04 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>
CC: Alexandre Courbot <gnurou@gmail.com>, <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 05/17] mips: loongson: use GPIO driver on CONFIG_GPIOLIB
Date: Tue, 12 Mar 2013 19:12:18 +0900
Message-ID: <1363083150-30964-6-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO driver uses gpiolib, thus it should be compiled when
CONFIG_GPIOLIB is defined and not only CONFIG_GENERIC_GPIO.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/mips/loongson/common/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/loongson/common/Makefile b/arch/mips/loongson/common/Makefile
index e526488..4c57b3e 100644
--- a/arch/mips/loongson/common/Makefile
+++ b/arch/mips/loongson/common/Makefile
@@ -4,7 +4,7 @@
 
 obj-y += setup.o init.o cmdline.o env.o time.o reset.o irq.o \
     pci.o bonito-irq.o mem.o machtype.o platform.o
-obj-$(CONFIG_GENERIC_GPIO) += gpio.o
+obj-$(CONFIG_GPIOLIB) += gpio.o
 
 #
 # Serial port support
-- 
1.8.1.5

