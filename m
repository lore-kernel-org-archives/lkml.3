Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaIPSu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:50:56 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64712 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbaIPSux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:50:53 -0400
From: tim.gardner@canonical.com
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 3.17-rc5] =?UTF-8?q?kconfig:=20Suppress=20warning:=20=E2=80=98j?= =?UTF-8?q?ump=E2=80=99=20may=20be=20used=20uninitialized?=
Date: Tue, 16 Sep 2014 12:50:42 -0600
Message-Id: <1410893442-17181-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Gardner <tim.gardner@canonical.com>

In file included from scripts/kconfig/zconf.tab.c:2537:0:
scripts/kconfig/menu.c: In function ‘get_symbol_str’:
scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
     jump->offset = strlen(r->s);
                  ^
scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
  struct jump_key *jump;
                   ^
  HOSTLD  scripts/kconfig/conf

gcc 4.9.1

Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---

Is gcc 4.9 dumber then 4.8 ? gcc 4.8 doesn't produce this warning.

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
2.1.0

