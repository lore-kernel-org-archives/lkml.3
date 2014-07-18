Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759137AbaGRAtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 20:49:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551AbaGRAtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 20:49:19 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 18 Jul 2014 10:48:28 +1000
Subject: [PATCH 0/5] clean-up patch for autofs4
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140718004353.19389.48104.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
 I believe you shepherd autofs4 patches at present.
 The following 5 patches are some simple cleanups.
 4 are trivial.  One (the third) is a very simple optimization
 which will be more important after the next patch set, but
 is simple enough to be included now.

 The next patch set will make autofs4 RCU-walk friendly so that in the
 common case a filename lookup can walk across an autofs4 filesystem
 without taking spinlocks or refcounts.  I'll submit that once more
 testing and review have convinced Ian and myself that it is ready.

 Thanks,
 NeilBrown
 
---

NeilBrown (5):
      autofs4: remove unused autofs4_ispending()
      autofs4: remove a redundant assignment
      autofs4: don't take spinlock when not needed in autofs4_lookup_expiring
      autofs4: remove some unused inline functions.
      autofs4: comment typo: remove a a doubled word.


 fs/autofs4/autofs_i.h |   63 -------------------------------------------------
 fs/autofs4/expire.c   |    1 -
 fs/autofs4/root.c     |   10 +++++---
 3 files changed, 7 insertions(+), 67 deletions(-)

-- 
Signature

