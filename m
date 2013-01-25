Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab3AYP3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 10:29:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62186 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab3AYP3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 10:29:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ben Dooks <ben-linux@fluff.org>, David Airlie <airlied@linux.ie>,
        James Morris <james.l.morris@oracle.com>, Rob Clark <rob@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH v2 0/5] ARM build regressions in 3.8
Date: Fri, 25 Jan 2013 15:28:26 +0000
Message-Id: <1359127711-19070-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:wYeTqTtl2nXFuiRPiuNle1PWanFmTD2BnzdE2BoI2c3
 XTd2tLFFKsr6upQ+sdLrp37d5f1d//xa5NyfJfqEbIJHg9yWYA
 Q28L7K2yOpVFp67hBrsM3LDj27BPgISOIDyxx9CRaYry9dLBt7
 7xKf7uwacMYTzgfp7lxeKFONb4wvM3RmK+A1BUL86f31OtNKM9
 4RqkXetHA/a7RkNNyBYRZSAffkN5L5dXJySW1leAdeU60PZ0Tb
 OSgHMhVCJX99UsT5MQJTevFuJMwERuQI2G7MUySPKHgwTJ9LDb
 D7+RZeBfhtmTXhOgKnH1V1W5rF+imCdEYuQ0KY9sGOp+f1Qp3e
 EufXiNa+KQQAHRtJK1g1+Upl/54EjFeh2liheHFbm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is what remains from my previous 15 patch series,
the other patches have largely been obsoleted by
fixes from other people that found the same issues.

The samsung and w90x900 fixes should probably go through
the arm-soc tree, while I'd hope James Morris to pick
up the seccomp one and Dave Airlie to take the
exynos drm patch, but we can also put both into arm-soc
if that makes their lifes easier.

On the compressed/head.S patch, I'm still awaiting
feedback. It's not urgent since it is only a warning.

Arnd Bergmann (5):
  samples/seccomp: be less stupid about cross compiling
  ARM: compressed/head.S: work around new binutils warning
  ARM: samsung: fix assembly syntax for new gas
  ARM: w90x900: fix legacy assembly syntax
  drm/exynos: don't include plat/gpio-cfg.h

 arch/arm/boot/compressed/Makefile                |  2 +-
 arch/arm/boot/compressed/head.S                  | 12 ++++++++++++
 arch/arm/mach-s3c24xx/include/mach/debug-macro.S | 12 ++++++------
 arch/arm/mach-s3c24xx/include/mach/entry-macro.S |  4 ++--
 arch/arm/mach-s3c24xx/pm-h1940.S                 |  2 +-
 arch/arm/mach-s3c24xx/sleep-s3c2410.S            | 12 ++++++------
 arch/arm/mach-s3c24xx/sleep-s3c2412.S            | 12 ++++++------
 arch/arm/mach-w90x900/include/mach/entry-macro.S |  4 ++--
 arch/arm/plat-samsung/include/plat/debug-macro.S | 18 +++++++++---------
 drivers/gpu/drm/exynos/exynos_hdmi.c             |  1 -
 samples/seccomp/Makefile                         |  2 ++
 11 files changed, 47 insertions(+), 34 deletions(-)

-- 
1.7.10.4
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: David Airlie <airlied@linux.ie>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Rob Clark <rob@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org
