Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaFDRAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:00:06 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:54374 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFDRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:00:05 -0400
Date: Wed, 4 Jun 2014 12:59:53 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [GIT PULL] last minute percpu fix for v3.15-rc8
Message-ID: <20140604165953.GJ5004@htj.dyndns.org>
References: <20140604163700.GH5004@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604163700.GH5004@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

My script applied the patch with the wrong author.  It should have
been Heiko instead of Sebastian.  I fixed up percpu/for-3.15-fixes
branch accordingly.  The updated pull-request output follows.  There
is no content change.

Thanks.

The following changes since commit 5a838c3b60e3a36ade764cf7751b8f17d7c9c2da:

  percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree() (2014-04-14 16:18:06 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.15-fixes

for you to fetch changes up to 00930b6b56d260b13924b9600aa37652f538edbf:

  percpu-refcount: fix usage of this_cpu_ops (2014-06-04 12:57:24 -0400)

----------------------------------------------------------------
Heiko Carstens (1):
      percpu-refcount: fix usage of this_cpu_ops

 include/linux/percpu-refcount.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 95961f0..0afb48f 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -110,7 +110,7 @@ static inline void percpu_ref_get(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 	else
 		atomic_inc(&ref->count);
 
@@ -139,7 +139,7 @@ static inline bool percpu_ref_tryget(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR)) {
-		__this_cpu_inc(*pcpu_count);
+		this_cpu_inc(*pcpu_count);
 		ret = true;
 	}
 
@@ -164,7 +164,7 @@ static inline void percpu_ref_put(struct percpu_ref *ref)
 	pcpu_count = ACCESS_ONCE(ref->pcpu_count);
 
 	if (likely(REF_STATUS(pcpu_count) == PCPU_REF_PTR))
-		__this_cpu_dec(*pcpu_count);
+		this_cpu_dec(*pcpu_count);
 	else if (unlikely(atomic_dec_and_test(&ref->count)))
 		ref->release(ref);
 
