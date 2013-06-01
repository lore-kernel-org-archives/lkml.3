Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab3FAV1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 17:27:22 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:41502 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376Ab3FAV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 17:27:19 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next resend] blackfin: bf533-stamp: Remove bogus "||"
Date: Sat,  1 Jun 2013 23:27:00 +0200
Message-Id: <1370122020-18686-1-git-send-email-geert@linux-m68k.org>
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
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Mike Frysinger <vapier@gentoo.org>
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

