Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3IVRGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 13:06:10 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:54524 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab3IVRGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 13:06:08 -0400
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
To: mmarek@suse.cz
Cc: yann.morin.1998@free.fr, bpoirier@suse.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: =?y?q?=5BPATCH=20V2=5D=20kconfig/menu=2Ec=3A=20fix=20uninitialized=20variable=20warning?=
Date: Sun, 22 Sep 2013 22:35:57 +0530
Message-Id: <1379869557-23116-1-git-send-email-maddy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092217-5564-0000-0000-000009D4A99F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In file included from scripts/kconfig/zconf.tab.c:2537:0:
scripts/kconfig/menu.c: In function ‘get_symbol_str’:
scripts/kconfig/menu.c:586:18: warning: ‘jump’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
     jump->offset = r->len - 1;
                  ^
scripts/kconfig/menu.c:547:19: note: ‘jump’ was declared here
  struct jump_key *jump;
                   ^
Change V2:

1)Added comment as suggested.

Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
---
 scripts/kconfig/menu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index c1d5320..32ee2d5 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -544,7 +544,8 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 {
 	int i, j;
 	struct menu *submenu[8], *menu, *location = NULL;
-	struct jump_key *jump;
+	/* Initializing to avoid a spurious warning observed in gcc 4.8.0 */
+	struct jump_key *jump = NULL;
 
 	str_printf(r, _("Prompt: %s\n"), _(prop->text));
 	menu = prop->menu->parent;
-- 
1.7.10.4

