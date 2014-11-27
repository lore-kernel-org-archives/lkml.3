Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189AbaK0Gyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:54:39 -0500
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:41192
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750812AbaK0Gyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:54:38 -0500
From: Anish Bhatt <anish@chelsio.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr,
        Anish Bhatt <anish@chelsio.com>
Subject: [PATCH] Fix -Wmaybe-uninitialized warning seen with make menuconfig
Date: Wed, 26 Nov 2014 22:54:28 -0800
Message-Id: <1417071268-9422-1-git-send-email-anish@chelsio.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following :

scripts/kconfig/menu.c: In function 'get_symbol_str':
scripts/kconfig/menu.c:590:18: warning: 'jump' may be used uninitialized in
this function [-Wmaybe-uninitialized]
     jump->offset = strlen(r->s);
                  ^
scripts/kconfig/menu.c:551:19: note: 'jump' was declared here
  struct jump_key *jump;

Signed-off-by: Anish Bhatt <anish@chelsio.com>
---
 scripts/kconfig/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index a26cc5d..584e0fc 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -548,7 +548,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 {
 	int i, j;
 	struct menu *submenu[8], *menu, *location = NULL;
-	struct jump_key *jump;
+	struct jump_key *jump = NULL;
 
 	str_printf(r, _("Prompt: %s\n"), _(prop->text));
 	menu = prop->menu->parent;
-- 
2.1.3

