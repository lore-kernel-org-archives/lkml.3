Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab3G3HNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:13:44 -0400
Received: from intranet.asianux.com ([58.214.24.6]:57138 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab3G3HNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:13:43 -0400
X-Spam-Score: -100.8
Message-ID: <51F76769.5050205@asianux.com>
Date: Tue, 30 Jul 2013 15:12:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>, jonas@southpole.se,
        liqin.chen@sunplusct.com, lennox.wu@gmail.com
CC: linux-hexagon@vger.kernel.org, linux@openrisc.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arch: *: Kconfig: add "kernel/Kconfig.freezer" to "arch/*/Kconfig"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All architectures include "kernel/Kconfig.freezer" except three left,
so let them include it too, or 'allmodconfig' will report error.

The related errors: (with allmodconfig for openrisc):

    CC      kernel/cgroup_freezer.o
  kernel/cgroup_freezer.c: In function 'freezer_css_online':
  kernel/cgroup_freezer.c:133:15: error: 'system_freezing_cnt' undeclared (first use in this function)
  kernel/cgroup_freezer.c:133:15: note: each undeclared identifier is reported only once for each function it appears in
  kernel/cgroup_freezer.c: In function 'freezer_css_offline':
  kernel/cgroup_freezer.c:157:15: error: 'system_freezing_cnt' undeclared (first use in this function)
  kernel/cgroup_freezer.c: In function 'freezer_attach':
  kernel/cgroup_freezer.c:200:4: error: implicit declaration of function 'freeze_task'
  kernel/cgroup_freezer.c: In function 'freezer_apply_state':
  kernel/cgroup_freezer.c:371:16: error: 'system_freezing_cnt' undeclared (first use in this function)


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 arch/hexagon/Kconfig  |    1 +
 arch/openrisc/Kconfig |    1 +
 arch/score/Kconfig    |    2 ++
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 33a9792..77d442a 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -158,6 +158,7 @@ source "kernel/Kconfig.hz"
 endmenu
 
 source "init/Kconfig"
+source "kernel/Kconfig.freezer"
 source "drivers/Kconfig"
 source "fs/Kconfig"
 
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index 99dbab1..d60bf98 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -55,6 +55,7 @@ config GENERIC_CSUM
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index c8def8b..5fc2375 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -87,6 +87,8 @@ config STACKTRACE_SUPPORT
 
 source "init/Kconfig"
 
+source "kernel/Kconfig.freezer"
+
 config MMU
 	def_bool y
 
-- 
1.7.7.6
