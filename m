Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab3ISH2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 03:28:39 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:60098 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3ISH2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 03:28:38 -0400
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
To: mmarek@suse.cz
Cc: yann.morin.1998@free.fr, bpoirier@suse.de, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: =?UTF-8?q?=5BPATCH=5Dkconfig/menu=2Ec=3A=20fix=20uninitialized=20variable=20warning?=
Date: Thu, 19 Sep 2013 12:58:17 +0530
Message-Id: <1379575697-6740-1-git-send-email-maddy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091907-2000-0000-0000-00000DC8C641
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
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
---
 scripts/kconfig/menu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index c1d5320..23b1827 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -544,7 +544,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 {
 	int i, j;
 	struct menu *submenu[8], *menu, *location = NULL;
-	struct jump_key *jump;
+	struct jump_key *jump = NULL;

 	str_printf(r, _("Prompt: %s\n"), _(prop->text));
 	menu = prop->menu->parent;
--
1.7.10.4

