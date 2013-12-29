Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3L2CKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55152 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237Ab3L2CKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:19 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, user-mode-linux-user@lists.sourceforge.net,
        "Jeff Dike" <jdike@addtoit.com>, "Richard Weinberger" <richard@nod.at>,
        "Sergei Trofimovich" <slyfox@gentoo.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        user-mode-linux-devel@lists.sourceforge.net
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.562737677@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 148/185] um: add missing declaration of 'getrlimit()'
 and friends
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergei Trofimovich <slyfox@gentoo.org>

commit fdfa4c952844fce881df8c76de9c7180cbe913ab upstream.

arch/um/os-Linux/start_up.c: In function 'check_coredump_limit':
arch/um/os-Linux/start_up.c:338:16: error: storage size of 'lim' isn't known
arch/um/os-Linux/start_up.c:339:2: error: implicit declaration of function 'getrlimit' [-Werror=implicit-function-declaration]

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
CC: Jeff Dike <jdike@addtoit.com>
CC: Richard Weinberger <richard@nod.at>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net
CC: user-mode-linux-user@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/um/os-Linux/start_up.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -15,6 +15,8 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include <asm/unistd.h>
 #include "init.h"
 #include "os.h"

