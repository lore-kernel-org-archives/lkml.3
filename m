Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaGGXyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 19:54:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaGGXyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>, Will Woods <wwoods@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 077/122] ia64: arch/ia64/include/uapi/asm/fcntl.h needs personality.h
Date: Mon,  7 Jul 2014 16:57:19 -0700
Message-Id: <20140707235736.563865077@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit f9af420fc8208d3add2fe3198dc5d8215f5a81ba upstream.

fs/notify/fanotify/fanotify_user.c: In function 'SYSC_fanotify_init':
fs/notify/fanotify/fanotify_user.c:726: error: implicit declaration of function 'personality'
fs/notify/fanotify/fanotify_user.c:726: error: 'PER_LINUX32' undeclared (first use in this function)
fs/notify/fanotify/fanotify_user.c:726: error: (Each undeclared identifier is reported only once
fs/notify/fanotify/fanotify_user.c:726: error: for each function it appears in.)

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Will Woods <wwoods@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/ia64/include/uapi/asm/fcntl.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/ia64/include/uapi/asm/fcntl.h
+++ b/arch/ia64/include/uapi/asm/fcntl.h
@@ -8,6 +8,7 @@
 #define force_o_largefile()	\
 		(personality(current->personality) != PER_LINUX32)
 
+#include <linux/personality.h>
 #include <asm-generic/fcntl.h>
 
 #endif /* _ASM_IA64_FCNTL_H */


