Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763Ab3JKBmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:42:38 -0400
Received: from intranet.asianux.com ([58.214.24.6]:48732 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab3JKBmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:42:36 -0400
X-Spam-Score: -100.8
Message-ID: <5257574D.1040604@asianux.com>
Date: Fri, 11 Oct 2013 09:41:33 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] include/asm-generic/atomic.h: use 'unsigned int' instead
 of 'unsigned long' for atomic_clear_mask()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For atomic_clear_mask(), 'v->counter' is 'int', so it is better to use
'unsigned int' instead of 'unsigned long' for parameter 'mask' to make
atomic_clear_mask() itself consistency.

And atomic_[set/clear]_mask() are pairs, the modification can also let
them consistent with each other.

Although the original implementation can not cause bugs, it is still
better to let it improved.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 include/asm-generic/atomic.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index 33bd2de..f31bff97 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -153,7 +153,7 @@ static inline int __atomic_add_unless(atomic_t *v, int a, int u)
  * Atomically clears the bits set in @mask from @v
  */
 #ifndef atomic_clear_mask
-static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
+static inline void atomic_clear_mask(unsigned int mask, atomic_t *v)
 {
 	unsigned long flags;
 
-- 
1.7.7.6
