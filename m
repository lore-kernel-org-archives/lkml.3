Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab3BMAZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:25:00 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:53869 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759199Ab3BMAY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:24:58 -0500
Date: Tue, 12 Feb 2013 16:24:56 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Steven Whitehouse <swhiteho@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vlad Yasevich <vyasevich@gmail.com>
Subject: [patch for-3.8] net, sctp: remove CONFIG_EXPERIMENTAL
In-Reply-To: <alpine.DEB.2.02.1302121207250.25566@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1302121619340.3805@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1302111344140.14071@chino.kir.corp.google.com> <1360662605.2719.13.camel@menhir> <CA+55aFzCRLy5AN24rJUvbLf5HNeumn=qtS0dA9f9+2CKOLgu7A@mail.gmail.com> <alpine.DEB.2.02.1302121207250.25566@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 Ah, look what I found in my mailbox from October 23.  The patch for dlm
 was merged, but this wasn't for some reason.  It's acked by the 
 maintainer so it should be good to go and fixes the reported build error:

        net/built-in.o: In function `sctp_crc32c':
        include/net/sctp/checksum.h:51: undefined reference to `crc32c'
        include/net/sctp/checksum.h:51: undefined reference to `crc32c'
        include/net/sctp/checksum.h:51: undefined reference to `crc32c'
        include/net/sctp/checksum.h:51: undefined reference to `crc32c'
        include/net/sctp/checksum.h:51: undefined reference to `crc32c'
        net/built-in.o:include/net/sctp/checksum.h:51: more undefined references to `crc32c' follow

 And I guess "dlm not being marked experimental for a long time" meant
 three months.

 net/sctp/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -3,8 +3,8 @@
 #
 
 menuconfig IP_SCTP
-	tristate "The SCTP Protocol (EXPERIMENTAL)"
-	depends on INET && EXPERIMENTAL
+	tristate "The SCTP Protocol"
+	depends on INET
 	depends on IPV6 || IPV6=n
 	select CRYPTO
 	select CRYPTO_HMAC
