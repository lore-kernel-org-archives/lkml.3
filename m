Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3HOVR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:17:56 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59120 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3HOVRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:17:44 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Sam Ravnborg <sam@ravnborg.org>, Kevin Hilman <khilman@linaro.org>,
        sedat.dilek@gmail.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 4/4] modules: do not depend on kconfig to set 'modules' option to symbol MODULES
Date: Thu, 15 Aug 2013 23:17:33 +0200
Message-Id: <11097a0367e48954ecf616f9b0df48d86835dd0d.1376600922.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Currently, the MODULES symbol is special-cased in different places in the
kconfig language. For example, if no symbol is defined to enable tristates,
then kconfig looks up for a symbol named 'MODULES', and forces the 'modules'
option onto that symbol.

This causes problems as such:
  - since MODULES is special-cased, reading the configuration with
    KCONFIG_ALLCONFIG set will forcibly set MODULES to be 'valid' (ie.
    it has a valid value), when no such value was previously set. So
    MODULES defaults to 'n' unless it is present in KCONFIG_ALLCONFIG
  - other third-party projects may decide that 'MODULES' plays a different
    role for them

This has been exposed by cset #cfa98f2e:
    kconfig: do not override symbols already set
and reported by Stephen in:
    http://marc.info/?l=linux-next&m=137592137915234&w=2

As suggested by Sam, we explicitly define the MODULES symbol to be the
tristate-enabler. This will allow us to drop special-casing of MODULES
in the kconfig language, later.

(Note: this patch is not a fix to Stephen's issue, just a first step).

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: yann.morin.1998@free.fr
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: sedat.dilek@gmail.com
Cc: Theodore Ts'o <tytso@mit.edu>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 247084b..4d55e81 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1666,6 +1666,7 @@ config BASE_SMALL
 
 menuconfig MODULES
 	bool "Enable loadable module support"
+	option modules
 	help
 	  Kernel modules are small pieces of compiled code which can
 	  be inserted in the running kernel, rather than being
-- 
1.8.1.2

