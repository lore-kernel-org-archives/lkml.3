Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaBPNKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 08:10:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61904 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbaBPNK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 08:10:28 -0500
Message-ID: <5300B95F.3040306@fb.com>
Date: Sun, 16 Feb 2014 08:13:03 -0500
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-16_01:2014-02-14,2014-02-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.52575738102223e-13 kscore.compositescore=0
 circleOfTrustscore=28.9261618248808 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1402160054
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We have a small collection of fixes in my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

The big thing that stands out is a revert of a new ioctl.  Users haven't
shipped yet in btrfs-progs, and Dave Sterba found a better way to export
the information.

Anand Jain (1) commits (+8/-2):
    btrfs: fix null pointer deference at btrfs_sysfs_add_one+0x105

Liu Bo (1) commits (+0/-1):
    Btrfs: fix a lockdep warning when cleaning up aborted transaction

Filipe David Borba Manana (1) commits (+10/-0):
    Btrfs: use right clone root offset for compressed extents

Mitch Harder (1) commits (+1/-1):
    Btrfs: fix max_inline mount option

Chris Mason (1) commits (+0/-17):
    Revert "btrfs: add ioctl to export size of global metadata reservation"

Josef Bacik (1) commits (+9/-2):
    Btrfs: unset DCACHE_DISCONNECTED when mounting default subvol

Total: (6) commits (+28/-23)

 fs/btrfs/disk-io.c         |  1 -
 fs/btrfs/inode.c           |  2 +-
 fs/btrfs/ioctl.c           | 16 ----------------
 fs/btrfs/send.c            | 10 ++++++++++
 fs/btrfs/super.c           | 11 +++++++++--
 fs/btrfs/sysfs.c           | 10 ++++++++--
 include/uapi/linux/btrfs.h |  1 -
 7 files changed, 28 insertions(+), 23 deletions(-)
