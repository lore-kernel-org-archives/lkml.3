Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaLITjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 14:39:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:28292 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbaLITji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 14:39:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="496215966"
Date: Wed, 10 Dec 2014 03:38:17 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: kbuild-all@01.org, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org
Subject: [PATCH tj-misc] bitmap: bitmap_print_list() can be static
Message-ID: <20141209193817.GA27635@lkp-sb04>
References: <201412100354.d6xN5OCa%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412100354.d6xN5OCa%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lib/bitmap.c:574:6: sparse: symbol 'bitmap_print_list' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 bitmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/bitmap.c b/lib/bitmap.c
index c5dd40e..dc43a01 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -571,7 +571,7 @@ static inline void bscnl_emit(int rbot, int rtop, bool first,
 		printfn(printfn_data, "%d-%d", rbot, rtop);
 }
 
-void bitmap_print_list(const unsigned long *maskp, int nmaskbits,
+static void bitmap_print_list(const unsigned long *maskp, int nmaskbits,
 		       bitmap_printfn_t printfn, void *printfn_data)
 {
 	bool first = true;
