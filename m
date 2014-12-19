Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaLSOke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:40:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3302 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbaLSOkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:40:33 -0500
Date: Fri, 19 Dec 2014 09:40:28 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs pull part two
Message-ID: <20141219144028.GA29009@ret.masoncoding.com>
Mail-Followup-To: Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-19_04:2014-12-19,2014-12-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=2 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412190145
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

It has part two of our merge window patches.  These are all from Filipe,
and fix some really hard to find races that can cause corruptions.  Most
of them involved block group removal (balance) or discard.

Filipe Manana (4) commits (+20/-25):
    Btrfs: fix fs corruption on transaction abort if device supports discard (+6/-10)
    Btrfs: always clear a block group node when removing it from the tree (+3/-0)
    Btrfs: remove non-sense btrfs_error_discard_extent() function (+6/-12)
    Btrfs: ensure deletion from pinned_chunks list is protected (+5/-3)

Total: (4) commits (+20/-25)

 fs/btrfs/ctree.h            |  4 ++--
 fs/btrfs/disk-io.c          |  6 ------
 fs/btrfs/extent-tree.c      | 23 +++++++++++------------
 fs/btrfs/free-space-cache.c | 12 +++++++-----
 4 files changed, 20 insertions(+), 25 deletions(-)
