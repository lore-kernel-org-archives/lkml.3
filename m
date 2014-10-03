Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbaJCXcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:32:07 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:38774 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757374AbaJCXcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:32:01 -0400
X-Originating-IP: 75.92.167.159
Date: Fri, 3 Oct 2014 16:31:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Matt Turner <mattst88@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        =?utf-8?B?6JSh5q2j6b6Z?= <zhenglong.cai@cs2c.com.cn>,
        Tejun Heo <tj@kernel.org>, Fabian Frederick <fabf@skynet.be>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Peter Foley <pefoley2@pefoley.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the
 EXPERT menu
Message-ID: <20141003233139.GA16079@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 03b8c7b623c80af264c4c8d6111e5c6289933666 ("futex: Allow
architectures to skip futex_atomic_cmpxchg_inatomic() test") added the
HAVE_FUTEX_CMPXCHG symbol right below FUTEX.  This placed it right in
the middle of the options for the EXPERT menu.  However,
HAVE_FUTEX_CMPXCHG does not depend on EXPERT or FUTEX, so Kconfig stops
placing items in the EXPERT menu, and displays the remaining several
EXPERT items (starting with EPOLL) directly in the General Setup menu.

Since both users of HAVE_FUTEX_CMPXCHG only select it "if FUTEX", make
HAVE_FUTEX_CMPXCHG itself depend on FUTEX.  With this change, the
subsequent items display as part of the EXPERT menu again; the EMBEDDED
menu now appears as the next top-level item in the General Setup menu,
which makes General Setup much shorter and more usable.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Posting for review.  I can upstream this through the tiny tree.

Personally, I'd consider this a bit of a bug in Kconfig; ideally,
Kconfig should only consider symbols with prompt strings when
considering what to display in a menu.  However, in the interim, this
one-line patch drastically improves the usability of the "General Setup"
config menu.

 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index 31505a5..80a6907 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1477,6 +1477,7 @@ config FUTEX
 
 config HAVE_FUTEX_CMPXCHG
 	bool
+	depends on FUTEX
 	help
 	  Architectures should select this if futex_atomic_cmpxchg_inatomic()
 	  is implemented and always working. This removes a couple of runtime
-- 
2.1.1

