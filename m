Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3JBFZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:25:05 -0400
Received: from mout.web.de ([212.227.17.12]:57136 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab3JBFYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:24:37 -0400
From: Martin Walch <walch.martin@web.de>
Cc: Michal Marek <mmarek@suse.cz>, Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        Alan Cox <alan@linux.intel.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] kconfig: adjust warning message for conflicting types
Date: Wed, 02 Oct 2013 07:24:33 +0200
Message-ID: <2865108.QhoiiS6j3s@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K0:iNCPwFBi/R9FQLjnZ/BwfXTkzoLfeKkq2MS2CwBPl74DRKL20yq
 Pze7hLl0TnLnN9NqlP7ZnTNWIB9yvxrdTgPFwFAlzsODxKHQTvc1xFDMxBBPcaqvhQ3SNx/
 JfIuCfWzGcdiM+wYMAbgyJQt0GBnrJR+yEMkTOmCR8jRJeYXOketieD1bLhtg3nR0hE5rUC
 5fQrpgP90l1LVwUxyf/pA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Wed, 2 Oct 2013 06:58:01 +0200
Subject: [PATCH 3/4] kconfig: adjust warning message for conflicting types

Adjust warning: a second symbol type does *not* replace the first one.

Signed-off-by: Martin Walch <walch.martin@web.de>
---
 scripts/kconfig/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index b970101..e511df5 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -119,7 +119,7 @@ void menu_set_type(int type)
 		sym->type = type;
 		return;
 	}
-	menu_warn(current_entry, "type of '%s' redefined from '%s' to '%s'",
+	menu_warn(current_entry, "type of '%s' not redefined from '%s' to '%s'",
 	    sym->name ? sym->name : "<choice>",
 	    sym_type_name(sym->type), sym_type_name(type));
 }
-- 
1.8.1.5


