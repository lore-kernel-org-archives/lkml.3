Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235AbbAWSt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:49:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15410 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbbAWStY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:49:24 -0500
Date: Fri, 23 Jan 2015 13:49:18 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs fixes
Message-ID: <20150123184911.GA17437@ret.masoncoding.com>
Mail-Followup-To: Chris Mason <clm@fb.com>, torvalds@linux-foundation.org,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-23_06:2015-01-23,2015-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=29.4129509548051
 compositescore=0.939076664828693 urlsuspect_oldscore=0.939076664828693
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501230171
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We have a few fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Qu Wenruo's batch fix a regression between some our merge window pull
and the inode_cache feature.  The rest are smaller bugs.

Qu Wenruo (2) commits (+11/-1):
    btrfs: Don't call btrfs_start_transaction() on frozen fs to avoid deadlock. (+10/-0)
    btrfs: Fix the bug that fs_info->pending_changes is never cleared. (+1/-1)

Satoru Takeuchi (1) commits (+1/-1):
    btrfs: fix state->private cast on 32 bit machines

David Sterba (1) commits (+2/-2):
    btrfs: sync ioctl, handle errors after transaction start

Filipe Manana (1) commits (+2/-1):
    Btrfs: fix race deleting block group from space_info->ro_bgs list

Tsutomu Itoh (1) commits (+1/-1):
    Btrfs: fix incorrect freeing in scrub_stripe

Total: (6) commits (+17/-6)

 fs/btrfs/ctree.h       |  1 +
 fs/btrfs/extent-tree.c |  2 +-
 fs/btrfs/extent_io.c   |  2 +-
 fs/btrfs/scrub.c       |  2 +-
 fs/btrfs/super.c       | 14 ++++++++++++--
 fs/btrfs/transaction.c |  2 +-
 6 files changed, 17 insertions(+), 6 deletions(-)
