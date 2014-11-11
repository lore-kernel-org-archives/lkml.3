Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaKKIPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 03:15:38 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37283 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbaKKIPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 03:15:36 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 04/21] backports: grant parsers access to kconfig config and menuconfig
Date: Tue, 11 Nov 2014 00:14:55 -0800
Message-Id: <1415693712-23743-5-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415693712-23743-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

Allow parsers to query the type of option used, either config
or menuconfig. This will be used later.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 lib/kconfig.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kconfig.py b/lib/kconfig.py
index 179121a..3562630 100644
--- a/lib/kconfig.py
+++ b/lib/kconfig.py
@@ -7,7 +7,7 @@ import os, re
 src_line = re.compile(r'^\s*source\s+"?(?P<src>[^\s"]*)"?\s*$')
 tri_line = re.compile(r'^(?P<spc>\s+)tristate')
 bool_line = re.compile(r'^(?P<spc>\s+)bool')
-cfg_line = re.compile(r'^(config|menuconfig)\s+(?P<sym>[^\s]*)')
+cfg_line = re.compile(r'^(?P<opt>config|menuconfig)\s+(?P<sym>[^\s]*)')
 sel_line = re.compile(r'^(?P<spc>\s+)select\s+(?P<sym>[^\s]*)\s*$')
 backport_line = re.compile(r'^\s+#(?P<key>[ch]-file|module-name)\s*(?P<name>.*)')
 
-- 
2.1.1

