Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaCaS6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:58:23 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37674 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaCaS6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:58:22 -0400
Date: Mon, 31 Mar 2014 14:58:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [GIT PULL] percpu changes for v3.15-rc1
Message-ID: <20140331185817.GA28901@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

percpu allocation is now popular enough for the extremely naive range
allocator to cause scalability issues.  The existing allocator
linearly scanned the allocation map on both alloc and free without
making use of hint or anything.  Al reimplemented the range allocator
so that it can use binary search instead of linear scan during free
and alloc path uses simple hinting to avoid scanning in common cases.
Combined, the new allocator resolves the scalability issue percpu
allocator was showing during container benchmark workload.

The following changes since commit 0f0ca14386e0431fbedaae5efc550d46cf93b9cf:

  Merge tag 'hwmon-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging (2014-02-22 08:29:25 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.15

for you to fetch changes up to 21ddfd38ee9aac804d22beaceed4c7b903cca234:

  percpu: renew the max_contig if we merge the head and previous block (2014-03-29 09:29:42 -0400)

Thanks.

----------------------------------------------------------------
Al Viro (4):
      perpcu: fold pcpu_split_block() into the only caller
      percpu: store offsets instead of lengths in ->map[]
      percpu: speed alloc_pcpu_area() up
      percpu: allocation size should be even

Jianyu Zhan (1):
      percpu: renew the max_contig if we merge the head and previous block

 mm/percpu.c | 208 ++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 112 insertions(+), 96 deletions(-)

-- 
tejun
