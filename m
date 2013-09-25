Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab3IYXUS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:20:18 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:57149 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab3IYXUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:20:14 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RFC PATCH v4 10/40] bitops: Document the difference in indexing
 between fls() and __fls()
To: akpm@linux-foundation.org, mgorman@suse.de, dave@sr71.net,
        hannes@cmpxchg.org, tony.luck@intel.com, matthew.garrett@nebula.com,
        riel@redhat.com, arjan@linux.intel.com,
        srinivas.pandruvada@linux.intel.com, willy@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl
Cc: gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, andi@firstfloor.org,
        isimatu.yasuaki@jp.fujitsu.com, santosh.shilimkar@ti.com,
        kosaki.motohiro@gmail.com, srivatsa.bhat@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 04:45:56 +0530
Message-ID: <20130925231554.26184.87472.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
References: <20130925231250.26184.31438.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092523-6102-0000-0000-0000043C7F5C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fls() indexes the bits starting with 1, ie., from 1 to BITS_PER_LONG
whereas __fls() uses a zero-based indexing scheme (0 to BITS_PER_LONG - 1).
Add comments to document this important difference.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/include/asm/bitops.h      |    4 ++++
 include/asm-generic/bitops/__fls.h |    5 +++++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 41639ce..9186e4a 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -388,6 +388,10 @@ static inline unsigned long ffz(unsigned long word)
  * @word: The word to search
  *
  * Undefined if no set bit exists, so code should check against 0 first.
+ *
+ * Note: __fls(x) is equivalent to fls(x) - 1. That is, __fls() uses
+ * a zero-based indexing scheme (0 to BITS_PER_LONG - 1), where
+ * __fls(1) = 0, __fls(2) = 1, and so on.
  */
 static inline unsigned long __fls(unsigned long word)
 {
diff --git a/include/asm-generic/bitops/__fls.h b/include/asm-generic/bitops/__fls.h
index a60a7cc..ae908a5 100644
--- a/include/asm-generic/bitops/__fls.h
+++ b/include/asm-generic/bitops/__fls.h
@@ -8,6 +8,11 @@
  * @word: the word to search
  *
  * Undefined if no set bit exists, so code should check against 0 first.
+ *
+ * Note: __fls(x) is equivalent to fls(x) - 1. That is, __fls() uses
+ * a zero-based indexing scheme (0 to BITS_PER_LONG - 1), where
+ * __fls(1) = 0, __fls(2) = 1, and so on.
+ *
  */
 static __always_inline unsigned long __fls(unsigned long word)
 {

