Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbaKUEWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 23:22:35 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62450 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKUEWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 23:22:34 -0500
MIME-Version: 1.0
Date: Fri, 21 Nov 2014 12:22:32 +0800
Message-ID: <CAHnt0GXeTAmAaa3queHDP2kssYESgHLmohXj41F04gQvcB__ug@mail.gmail.com>
Subject: [PATCH] scripts/kconfig/menu.c warning for uninitialized "jump"
From: Peter Teoh <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This warning was found in v3.18-rc3-68-g20f3963 of Linus git-tree.

  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
In file included from scripts/kconfig/zconf.tab.c:2537:0:
scripts/kconfig/menu.c: In function ‘get_symbol_str’:
scripts/kconfig/menu.c:590:18: warning: ‘jump’ may be used
uninitialized in this function [-Wmaybe-uninitialized]
     jump->offset = strlen(r->s);
                  ^
scripts/kconfig/menu.c:551:19: note: ‘jump’ was declared here
  struct jump_key *jump;
                   ^
  HOSTCC  scripts/kconfig/lxdialog/checklist.o
  HOSTCC  scripts/kconfig/lxdialog/util.o
  HOSTCC  scripts/kconfig/lxdialog/inputbox.o


The patch is provided below, to put in the extra checks for jump, and
it also added extra brackets to make the logical expression less
cryptic.

Signed-off-by: Peter Teoh <htmldeveloper@gmail.com>

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index a26cc5d..4d7eb61 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -586,7 +586,7 @@ static void get_prompt_str(struct gstr *r, struct
property *prop,
                str_printf(r, _("  Location:\n"));
                for (j = 4; --i >= 0; j += 2) {
                        menu = submenu[i];
-                       if (head && location && menu == location)
+                       if (head && location && (menu == location) && (jump))
                                jump->offset = strlen(r->s);
                        str_printf(r, "%*c-> %s", j, ' ',
                                   _(menu_get_prompt(menu)));
