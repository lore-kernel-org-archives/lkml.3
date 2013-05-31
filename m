Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3EaJmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 05:42:23 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:48860 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab3EaJmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 05:42:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] blackfin: bf533-stamp: Remove bogus "||"
Date: Fri, 31 May 2013 11:40:50 +0200
Message-Id: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/blackfin/mach-bf533/boards/stamp.c:545:2: error: operator '||' has no right operand
arch/blackfin/mach-bf533/boards/stamp.c:662:3: error: 'bfin_snd_resources' undeclared here (not in a function)
arch/blackfin/mach-bf533/boards/stamp.c:662:3: error: negative width in bit-field '<anonymous>'
arch/blackfin/mach-bf533/boards/stamp.c:665:21: error: 'bfin_snd_data' undeclared here (not in a function)
make[4]: *** [arch/blackfin/mach-bf533/boards/stamp.o] Error 1

Introduced by commit 15502e0ca0da651b48c7def2983e7bb464349b2a ("blackfin:
Remove references to the bf5x_tdm driver"), which removed two config
options, but only one "||".

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8848472/

 arch/blackfin/mach-bf533/boards/stamp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 1ea1dda..4a8c2e3 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -542,7 +542,7 @@ static struct platform_device bfin_dpmc = {
 };
 
 #if defined(CONFIG_SND_BF5XX_I2S) || defined(CONFIG_SND_BF5XX_I2S_MODULE) || \
-	|| defined(CONFIG_SND_BF5XX_AC97) || \
+	defined(CONFIG_SND_BF5XX_AC97) || \
 	defined(CONFIG_SND_BF5XX_AC97_MODULE)
 
 #include <asm/bfin_sport.h>
-- 
1.7.0.4

