Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbaJGXdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:33:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075AbaJGXT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 3.14 08/37] init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu
Date: Tue,  7 Oct 2014 16:19:25 -0700
Message-Id: <20141007231827.323062562@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 init/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1389,6 +1389,7 @@ config FUTEX
 
 config HAVE_FUTEX_CMPXCHG
 	bool
+	depends on FUTEX
 	help
 	  Architectures should select this if futex_atomic_cmpxchg_inatomic()
 	  is implemented and always working. This removes a couple of runtime


