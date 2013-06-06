Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3FFUy0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:54:26 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46531 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab3FFUyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:54:24 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 0/8] format string usage clean ups
Date: Thu,  6 Jun 2013 13:52:17 -0700
Message-Id: <1370551945-8444-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series is a result of an audit of format string uses in the
kernel. Of two exploitable flaws, the first fix is now in the wireless
tree:

http://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/commit/?id=9538cbaab6e8b8046039b4b2eb6c9d614dc782bd

The second fix is here as patch 1 ("block: do not pass disk names               as format strings"). All the rest are either interface clean ups or
preventative measures to avoid accidents in the future.

There is still more needed before we can do something like this in 
the Makefile:

+# Enable format-security when it can stop the build, otherwise disable.
+KBUILD_CFLAGS  += $(call cc-option,\
+                       -Wformat -Wformat-security -Werror=format-security,\
+                       -Wno-format-security)

but I think this series covers the majority of potentially sensitive 
exposed infrastructure. 

Thanks,

-Kees

