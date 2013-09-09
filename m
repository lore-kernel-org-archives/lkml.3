Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751098Ab3IIHvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 03:51:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:50975 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab3IIHva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 03:51:30 -0400
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20kconfig/menu=2Ec=3A=20fix=20uninitialized=20variable=20warning?=
Date: Mon,  9 Sep 2013 13:21:20 +0530
Message-Id: <1378713080-3378-1-git-send-email-maddy@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090907-8878-0000-0000-000008C35112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scripts/kconfig/menu.c: In function ‘get_symbol_str’:
scripts/kconfig/menu.c:583:18: warning: ‘jump’ may be used uninitialized in
this function [-Wmaybe-uninitialized]
     jump->offset = r->len - 1;
                  ^
scripts/kconfig/menu.c:544:19: note: ‘jump’ was declared here
  struct jump_key *jump;
                   ^
Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
---
 scripts/kconfig/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 7e233a6..cfe4648 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -541,7 +541,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 {
 	int i, j;
 	struct menu *submenu[8], *menu, *location = NULL;
-	struct jump_key *jump;
+	struct jump_key *jump = NULL;

 	str_printf(r, _("Prompt: %s\n"), _(prop->text));
 	menu = prop->menu->parent;
--
1.8.2.1

