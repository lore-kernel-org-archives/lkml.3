Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbaJIVNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:13:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59746 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbaJIVMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:12:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Triplett <josh@joshtriplett.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 161/163] init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu
Date: Thu,  9 Oct 2014 14:03:06 -0700
Message-Id: <1412888588-26755-162-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Triplett <josh@joshtriplett.org>

commit 62b4d2041117f35ab2409c9f5c4b8d3dc8e59d0f upstream.

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
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 init/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/init/Kconfig b/init/Kconfig
index bb3a9f1..819800e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1402,6 +1402,7 @@ config FUTEX
 
 config HAVE_FUTEX_CMPXCHG
 	bool
+	depends on FUTEX
 	help
 	  Architectures should select this if futex_atomic_cmpxchg_inatomic()
 	  is implemented and always working. This removes a couple of runtime
-- 
1.9.1

