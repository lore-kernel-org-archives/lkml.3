Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3LRV3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:29:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36457 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3LRVNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Sunil K. Pandey" <sunil.k.pandey@intel.com>,
        "Kevin B. Smith" <kevin.b.smith@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.12 070/118] x86, build, icc: Remove uninitialized_var() from compiler-intel.h
Date: Wed, 18 Dec 2013 13:11:47 -0800
Message-Id: <20131218211221.435757666@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 503cf95c061a0551eb684da364509297efbe55d9 upstream.

When compiling with icc, <linux/compiler-gcc.h> ends up included
because the icc environment defines __GNUC__.  Thus, we neither need
nor want to have this macro defined in both compiler-gcc.h and
compiler-intel.h, and the fact that they are inconsistent just makes
the compiler spew warnings.

Reported-by: Sunil K. Pandey <sunil.k.pandey@intel.com>
Cc: Kevin B. Smith <kevin.b.smith@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-0mbwou1zt7pafij09b897lg3@git.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler-intel.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -28,8 +28,6 @@
 
 #endif
 
-#define uninitialized_var(x) x
-
 #ifndef __HAVE_BUILTIN_BSWAP16__
 /* icc has this, but it's called _bswap16 */
 #define __HAVE_BUILTIN_BSWAP16__


