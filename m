Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbaFTPsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:48:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26529 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932193AbaFTPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:48:28 -0400
Message-ID: <53A45909.50506@fb.com>
Date: Fri, 20 Jun 2014 11:53:45 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-20_06:2014-06-20,2014-06-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=7.34484695286142e-12 kscore.compositescore=0
 circleOfTrustscore=28.9261618248808 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406200180
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This fixes some lockups in btrfs reported with rc1.  It probably has
some performance impact because it is backing off our spinning locks
more often and switching to a blocking lock.  I'll be able to nail that
down next week, but for now I want to get the lockups taken care of.

Otherwise some more stack reduction and assorted fixes.

Miao Xie (5) commits (+304/-126):
    Btrfs: fix wrong error handle when the device is missing or is not writeable (+15/-7)
    Btrfs: make free space cache write out functions more readable (+93/-66)
    Btrfs: fix broken free space cache after the system crashed (+186/-44)
    Btrfs: fix deadlock when mounting a degraded fs (+9/-1)
    Btrfs: use bio_endio_nodec instead of open code (+1/-8)

Chris Mason (1) commits (+46/-34):
    Btrfs: fix deadlocks with trylock on tree nodes

Wang Shilong (1) commits (+6/-7):
    Btrfs: fix NULL pointer crash when running balance and scrub concurrently

Filipe Manana (1) commits (+0/-1):
    Btrfs: remove unused wait queue in struct extent_buffer

Qu Wenruo (1) commits (+9/-10):
    btrfs: Skip scrubbing removed chunks to avoid -ENOENT.

Total: (9) commits (+365/-178)

 fs/btrfs/ctree.h            |  13 ++-
 fs/btrfs/extent-tree.c      | 143 ++++++++++++++++++++++++++-------
 fs/btrfs/extent_io.h        |   1 -
 fs/btrfs/extent_map.c       |   2 +
 fs/btrfs/extent_map.h       |   1 +
 fs/btrfs/free-space-cache.c | 192 +++++++++++++++++++++++++++++---------------
 fs/btrfs/inode.c            |  41 +++++++---
 fs/btrfs/locking.c          |  80 ++++++++++--------
 fs/btrfs/scrub.c            |  19 +++--
 fs/btrfs/volumes.c          |  36 +++++----
 fs/btrfs/volumes.h          |   3 +
 11 files changed, 359 insertions(+), 172 deletions(-)
