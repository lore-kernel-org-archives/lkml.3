Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab3FRWsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:48:39 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48671 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933069Ab3FRWpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:23 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 03/14] kconfig/lxdialog: Use new mininimum resize definitions in conf_choice()
Date: Wed, 19 Jun 2013 00:44:59 +0200
Message-Id: <ff7b0c2c2430b5b116108441cbd0680efbef68d1.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sedat Dilek <sedat.dilek@gmail.com>

This is a cleanup which uses the proper (new) definitions and does
not change current behaviour.

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

---
Yann had some more ideas on improvements:

"What would be nice is an improvement that scales the choice window to
the number of entries in the choice. If there are a lot of choice
entries, then the choice popup grows in height (but does not overflow
the screen of course). So, instead of seeing only 6 entries, we'd see
as much as possible in the current screen.

Ditto for the width: the popup adapts to the longest prompt (but does
not overflow the screen either, of course), so prompts are not
truncated."

NOTE: This patch requires [1].

[1] http://marc.info/?l=linux-kbuild&m=137128726917166&w=2
---
 scripts/kconfig/mconf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 387dc8d..2396c5b 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -825,7 +825,9 @@ static void conf_choice(struct menu *menu)
 		dialog_clear();
 		res = dialog_checklist(prompt ? _(prompt) : _("Main Menu"),
 					_(radiolist_instructions),
-					 15, 70, 6);
+					MENUBOX_HEIGTH_MIN,
+					MENUBOX_WIDTH_MIN,
+					CHECKLIST_HEIGTH_MIN);
 		selected = item_activate_selected();
 		switch (res) {
 		case 0:
-- 
1.8.1.2

