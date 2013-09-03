Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3ICO3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:29:35 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:56139 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3ICO3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:29:34 -0400
Date: Tue, 3 Sep 2013 10:29:30 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu changes for v3.12-rc1
Message-ID: <20130903142930.GF10522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Just a single patch to update type verification macro for percpu
accessors.  Christoph is trying to replace __get_cpu_var() with
this_cpu accessors which needs this update.  There are still some
issues to be resolved but eventually the conversion patches are likely
to be routed through different trees, so I think it'd be convenient to
merge this commit early.

Thanks.

The following changes since commit a4244454df1296e90cc961c1b636b1176ef0d9a0:

  percpu-refcount: use RCU-sched insted of normal RCU (2013-06-16 16:12:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.12

for you to fetch changes up to abec1a806e0c3cf168999667d5fb6218398ef12a:

  percpu: Make __verify_pcu_ptr handle per cpu pointers to arrays (2013-08-23 16:08:27 -0400)

----------------------------------------------------------------
Christoph Lameter (1):
      percpu: Make __verify_pcu_ptr handle per cpu pointers to arrays

 include/linux/percpu-defs.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 27ef6b1..57e890a 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -22,9 +22,12 @@
  * Macro which verifies @ptr is a percpu pointer without evaluating
  * @ptr.  This is to be used in percpu accessors to verify that the
  * input parameter is a percpu pointer.
+ *
+ * + 0 is required in order to convert the pointer type from a
+ * potential array type to a pointer to a single item of the array.
  */
 #define __verify_pcpu_ptr(ptr)	do {					\
-	const void __percpu *__vpp_verify = (typeof(ptr))NULL;		\
+	const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL;	\
 	(void)__vpp_verify;						\
 } while (0)
 
--
tejun
