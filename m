Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbaIVQNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:13:45 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56482 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaIVQNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:13:44 -0400
X-Originating-IP: 75.92.167.159
Date: Mon, 22 Sep 2014 09:13:31 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] bloat-o-meter: Ignore syscall aliases SyS_ and compat_SyS_
Message-ID: <20140922161327.GA25256@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This avoids double-counting size changes in syscall implementations.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Posting for review.  I can upstream this through my new tiny tree.

 scripts/bloat-o-meter | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
index 549d0ab..23e78dc 100755
--- a/scripts/bloat-o-meter
+++ b/scripts/bloat-o-meter
@@ -20,6 +20,8 @@ def getsizes(file):
         if type in "tTdDbBrR":
             # strip generated symbols
             if name.startswith("__mod_"): continue
+            if name.startswith("SyS_"): continue
+            if name.startswith("compat_SyS_"): continue
             if name == "linux_banner": continue
             # statics and some other optimizations adds random .NUMBER
             name = re.sub(r'\.[0-9]+', '', name)
-- 
2.1.0

