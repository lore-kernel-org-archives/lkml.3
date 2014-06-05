Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaFEEpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:45:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaFEEVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Sunil K. Pandey" <sunil.k.pandey@intel.com>,
        "Kevin B. Smith" <kevin.b.smith@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 130/214] x86, build, icc: Remove uninitialized_var() from compiler-intel.h
Date: Wed,  4 Jun 2014 21:18:13 -0700
Message-Id: <20140605041657.181599514@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/compiler-intel.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/compiler-intel.h
+++ b/include/linux/compiler-intel.h
@@ -27,5 +27,3 @@
 #define __must_be_array(a) 0
 
 #endif
-
-#define uninitialized_var(x) x


