Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab3H1Sif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:38:35 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:59326 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab3H1Sie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:38:34 -0400
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Arnd Bergmann <arnd@arndb.de>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: [PATCH] ARC: remove console_verbose() from setup_arch()
Date: Wed, 28 Aug 2013 20:38:18 +0200
Message-Id: <1377715098-2347-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It prevents kernel parameters such as 'loglevel' from doing their job.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/kernel/setup.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arc/kernel/setup.c b/arch/arc/kernel/setup.c
index 6b08345..b011f8c 100644
--- a/arch/arc/kernel/setup.c
+++ b/arch/arc/kernel/setup.c
@@ -357,8 +357,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	root_mountflags &= ~MS_RDONLY;
 
-	console_verbose();
-
 #if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
-- 
1.7.9.5

