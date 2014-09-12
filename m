Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaILQfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:35:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3539 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751903AbaILQfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:35:34 -0400
Message-ID: <541320D0.4060603@fb.com>
Date: Fri, 12 Sep 2014 12:35:28 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs for rc5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-12_05:2014-09-12,2014-09-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.24953389249549e-12 kscore.compositescore=0
 circleOfTrustscore=28.9261618248808 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409120158
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

My for-linus branch has some fixes for the next rc:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Filipe is doing a careful pass through fsync problems, and these are the
fixes so far.  I'll have one more for rc6 that we're still testing.

My big commit is fixing up some inode hash races that Al Viro found
(thanks Al).

Filipe Manana (3) commits (+75/-21):
    Btrfs: fix corruption after write/fsync failure + fsync + log recovery (+9/-3)
    Btrfs: fix fsync data loss after a ranged fsync (+64/-17)
    Btrfs: fix crash while doing a ranged fsync (+2/-1)

Chris Mason (2) commits (+113/-70):
    Btrfs: use insert_inode_locked4 for inode creation (+109/-67)
    Btrfs: fix autodefrag with compression (+4/-3)

Dan Carpenter (1) commits (+15/-10):
    Btrfs: kfree()ing ERR_PTRs

Total: (6) commits (+203/-101)

 fs/btrfs/file.c     |   2 +-
 fs/btrfs/inode.c    | 191 +++++++++++++++++++++++++++++++++-------------------
 fs/btrfs/ioctl.c    |  32 +++++----
 fs/btrfs/tree-log.c |  77 ++++++++++++++++-----
 fs/btrfs/tree-log.h |   2 +
 5 files changed, 203 insertions(+), 101 deletions(-)
