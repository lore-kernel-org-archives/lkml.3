Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbaGOKal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:30:41 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54533 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040AbaGOKah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:30:37 -0400
Date: Tue, 15 Jul 2014 03:28:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Sasha Levin <sasha.levin@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] shmem: fix faulting into a hole while it's punched, take
 3
Message-ID: <alpine.LSU.2.11.1407150247540.2584@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here's my latest and hopefully last stab at fixing the trinity
hole-punch starvation issue that became known as CVE-2014-4171.

You may prefer to hear a testing update from Sasha and Vlastimil before
paying any attention to these, or you may prefer to add them into mmotm
for wider testing now: whichever you think appropriate.

Please throw away mmotm's
revert-shmem-fix-faulting-into-a-hole-while-its-punched.patch
and replace it by 1/2, which fixes that commit instead of reverting it.

Please throw away mmotm's
shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
and replace it by 2/2, which reworks the commit message and adds a fix.

Please keep the 3/3 I sent last time in mmotm
mm-fs-fix-pessimization-in-hole-punching-pagecache.patch
which remains valid.

In the end I decided that we had better look at it as two problems,
the trinity faulting starvation, and the indefinite punching loop,
so 1/2 and 2/2 present both solutions: belt and braces.

Which may be the best for fixing, but the worst for ease of backporting.
Vlastimil, I have prepared (and lightly tested) a 3.2.61-based version
of the combination of f00cdc6df7d7 and 1/2 and 2/2 (basically, I moved
vmtruncate_range from mm/truncate.c to mm/shmem.c, since nothing but
shmem ever implemented the truncate_range method).  It should give a
good hint for backports earlier and later: I'll send it privately to
you now, but keep in mind that it may need to be revised if today's
patches for 3.16 get revised again (I'll send it to Ben Hutchings
only when that's settled).

Thanks,
Hugh
