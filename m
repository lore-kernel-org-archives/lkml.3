Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab3DXWao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:30:44 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55470 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab3DXWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:30:28 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 5/8] kconfig: do not override symbols already set
Date: Thu, 25 Apr 2013 00:29:52 +0200
Message-Id: <cfa98f2e0ae956feca935573e977d7661a9561b9.1366841993.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

For randconfig, if a list of required symbols is specified with
KCONFIG_ALLCONFIG, such symbols do not "have a value" as per
sym_has_value(), but have the "valid" flag set.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/confdata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 306cbc1..2e35d4b 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -1109,7 +1109,7 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 	int i, cnt;
 
 	for_all_symbols(i, sym) {
-		if (sym_has_value(sym))
+		if (sym_has_value(sym) || (sym->flags & SYMBOL_VALID))
 			continue;
 		switch (sym_get_type(sym)) {
 		case S_BOOLEAN:
-- 
1.7.10.4

