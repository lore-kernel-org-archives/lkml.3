Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbaKAQFO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 12:05:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32719 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981AbaKAQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 12:05:10 -0400
Message-ID: <545504B1.9050408@fb.com>
Date: Sat, 1 Nov 2014 12:05:05 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-01_02:2014-10-31,2014-11-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=28.9261618248808
 compositescore=0.939076664828693 urlsuspect_oldscore=0.939076664828693
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411010164
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

We have a few fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Filipe is nailing down some problems with our skinny extent variation,
and Dave's patch fixes endian problems in the new super block checks.

Filipe Manana (2) commits (+4/-18):
    Btrfs: fix race that makes btrfs_lookup_extent_info miss skinny extent items (+0/-8)
    Btrfs: fix invalid leaf slot access in btrfs_lookup_extent() (+4/-10)

Josef Bacik (1) commits (+1/-0):
    Btrfs: properly clean up btrfs_end_io_wq_cache

David Sterba (1) commits (+22/-21):
    btrfs: use macro accessors in superblock validation checks

Total: (4) commits (+27/-39)

 fs/btrfs/ctree.h       |  2 +-
 fs/btrfs/disk-io.c     | 43 ++++++++++++++++++++++---------------------
 fs/btrfs/extent-tree.c | 18 ++----------------
 fs/btrfs/super.c       |  1 +
 fs/btrfs/tree-log.c    |  2 +-
 5 files changed, 27 insertions(+), 39 deletions(-)
