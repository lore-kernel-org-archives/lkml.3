Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832Ab3JaMHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:07:48 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48602 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3JaMHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:07:47 -0400
X-Originating-IP: 50.43.39.152
Date: Thu, 31 Oct 2013 05:07:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>, Nathan Lynch <ntl@pobox.com>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scripts/bloat-o-meter: Ignore changes in the size of
 linux_banner
Message-ID: <97cb4d841ddf10d44432487cf0b4de19f39349ed.1383221003.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux_banner can change size due to changes in the compiler, build
number, or the user@host the system was compiled on; ignore size changes
in linux_banner entirely.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/bloat-o-meter | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index 6129020..bf24f50 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -20,6 +20,7 @@ def getsizes(file):
         if type in "tTdDbBrR":
             # strip generated symbols
             if name[:6] == "__mod_": continue
+            if name == "linux_banner": continue
             # function names begin with '.' on 64-bit powerpc
             if "." in name[1:]: name = "static." + name.split(".")[0]
             sym[name] = sym.get(name, 0) + int(size, 16)
-- 
1.8.4.2

