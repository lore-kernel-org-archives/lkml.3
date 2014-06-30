Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaF3DRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 23:17:49 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:28902 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaF3DRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 23:17:47 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>, <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] script/kconfig: remove a warning for menucofig
Date: Mon, 30 Jun 2014 11:16:27 +0800
Message-Id: <1404098187-9638-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a warning when run "make menuconfig".

scripts/kconfig/menu.c: In function ‘get_symbol_str’:
scripts/kconfig/menu.c:591:18: warning: ‘jump’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
     jump->offset = strlen(r->s);
                  ^
scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
  struct jump_key *jump;
                   ^

It is because the compiler think "jump" is not initialized, though in fact
it is already initialized.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
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
2.0.0-rc0

