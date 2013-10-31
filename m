Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3JaMIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:08:15 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60275 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3JaMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:08:13 -0400
X-Originating-IP: 50.43.39.152
Date: Thu, 31 Oct 2013 05:08:07 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>, Nathan Lynch <ntl@pobox.com>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scripts/bloat-o-meter: Use .startswith rather than
 fragile slicing
Message-ID: <386dceda0e200f141a6b3863c81b795b3530489b.1383221003.git.josh@joshtriplett.org>
References: <97cb4d841ddf10d44432487cf0b4de19f39349ed.1383221003.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97cb4d841ddf10d44432487cf0b4de19f39349ed.1383221003.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

str.startswith has existed since at least Python 2.0, in 2000; use it
rather than a fragile comparison against an initial slice of a string,
which requires hard-coding the length of the string to compare against.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 scripts/bloat-o-meter | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index bf24f50..31c9531 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -19,7 +19,7 @@ def getsizes(file):
         size, type, name = l[:-1].split()
         if type in "tTdDbBrR":
             # strip generated symbols
-            if name[:6] == "__mod_": continue
+            if name.startswith("__mod_"): continue
             if name == "linux_banner": continue
             # function names begin with '.' on 64-bit powerpc
             if "." in name[1:]: name = "static." + name.split(".")[0]
-- 
1.8.4.2

