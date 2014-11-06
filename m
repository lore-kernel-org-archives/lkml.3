Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaKFMD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:03:28 -0500
Received: from mout.gmx.net ([212.227.17.22]:63040 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFMD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:03:27 -0500
From: =?UTF-8?q?Peter=20K=C3=BCmmel?= <syntheticpp@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Peter=20K=C3=BCmmel?= <syntheticpp@gmx.net>
Subject: [PATCH] =?UTF-8?q?kconfig:=20Fix=20warning=20"=E2=80=98jump?= =?UTF-8?q?=E2=80=99=20may=20be=20used=20uninitialized"?=
Date: Thu,  6 Nov 2014 13:03:00 +0100
Message-Id: <1415275383-15301-1-git-send-email-syntheticpp@gmx.net>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:Fh1IeF7yos4tnqXx+7Q2jcRb7Gjusgv5WAx5jRz/6wWgOPlBRm2
 PuJzw8ognfN57r0O9loPvNTYmPKrN+McM1DxbtVdSLf+1ZCLQL7bBB8APBpD5kEs8Rw9CkL
 2C10r38lbLOy0QVgxR0G5TmcdZOCvMk1cBtWODnerLqKzBxRIDKv4gpbO5XestgyVsMlI/D
 tttWLn8B5NOGOoGDN25GA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warning:
In file included from scripts/kconfig/zconf.tab.c:2537:0:
scripts/kconfig/menu.c: In function ‘get_symbol_str’:
scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used uninitialized in this function [-Wmaybe-uninitialized]
     jump->offset = strlen(r->s);

Simplifies the test logic because (head && local) means (jump != 0)
and makes GCC happy when checking if the jump pointer was initialized.

Signed-off-by: Peter Kümmel <syntheticpp@gmx.net>
---
 scripts/kconfig/menu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index a26cc5d..72c9dba 100644
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
@@ -586,7 +586,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 		str_printf(r, _("  Location:\n"));
 		for (j = 4; --i >= 0; j += 2) {
 			menu = submenu[i];
-			if (head && location && menu == location)
+			if (jump && menu == location)
 				jump->offset = strlen(r->s);
 			str_printf(r, "%*c-> %s", j, ' ',
 				   _(menu_get_prompt(menu)));
-- 
1.9.1

