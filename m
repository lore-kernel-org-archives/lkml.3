Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3JCR0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 13:26:31 -0400
Received: from mout.web.de ([212.227.17.11]:58830 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab3JCR02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 13:26:28 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Jiri Kosina <trivial@kernel.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Benjamin Poirier <bpoirier@suse.de>, Dirk Gouders <dirk@gouders.net>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <jdelvare@suse.de>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] kconfig: fix bug in search results string: use strlen(gstr->s), not gstr->len
Date: Thu, 03 Oct 2013 19:25:53 +0200
Message-ID: <2458916.eNjWPdyz4y@tacticalops>
User-Agent: KMail/4.11.1 (Linux/3.10.7-gentoo-r1-gnu; KDE/4.11.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:aVvE7i9nMenkxXlHgTZ8SSvWIpURiNtHzzKyxwapeF8cfII8fcX
 xoKa5d3+3jxXCFYqR/USAXJ6EmRxdqjkDE5nm5IW1N1hYVIIe2xtQ/RFEQgoG/RyLgThB12
 Z9yK+M8+Lu/YQDNtiTUnN6nKcc9yk1VKHj16qXBXjvy0PGoVC6tYnCViG2f09d1Qm8JcSPS
 wfk4Gh9jnFYtXuD7s9gqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Thu, 3 Oct 2013 18:35:16 +0200
Subject: [PATCH v2 5/5] kconfig: fix bug in search results string: use strlen(gstr->s), not gstr->len

The struct gstr has a capacity that may differ from the actual string length.

However, a string manipulation in the function search_conf made the assumption
that it is the same, which led to messing up some search results, especially
when the content of the gstr in use had not yet reached at least 63 chars.

Signed-off-by: Martin Walch <walch.martin@web.de>
---
 scripts/kconfig/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 9e69f19..db1512a 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -584,7 +584,7 @@ static void get_prompt_str(struct gstr *r, struct property *prop,
 		for (j = 4; --i >= 0; j += 2) {
 			menu = submenu[i];
 			if (head && location && menu == location)
-				jump->offset = r->len - 1;
+				jump->offset = strlen(r->s);
 			str_printf(r, "%*c-> %s", j, ' ',
 				   _(menu_get_prompt(menu)));
 			if (menu->sym) {
-- 
1.8.1.5

