Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaGDOmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:42:09 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21905 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752697AbaGDOmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:42:07 -0400
Message-ID: <53B6BD39.4010901@fb.com>
Date: Fri, 4 Jul 2014 10:42:01 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-04_04:2014-07-04,2014-07-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=5.21900300753941e-11 kscore.compositescore=0
 circleOfTrustscore=29.4129509548051 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407040167
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

We've queued up a few fixes in my for-linus branch, please pull:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Anand Jain (7) commits (+68/-10):
    btrfs: fix null pointer dereference in btrfs_show_devname when name is null (+2/-0)
    btrfs: fix null pointer dereference in clone_fs_devices when name is null (+7/-5)
    btrfs: create sprout should rename fsid on the sysfs as well (+10/-0)
    btrfs: rename add_device_membership to btrfs_kobj_add_device (+2/-2)
    btrfs: dev replace should replace the sysfs entry (+5/-0)
    btrfs: dev delete should remove sysfs entry (+26/-0)
    btrfs: dev add should add its sysfs entry (+16/-3)

Filipe Manana (4) commits (+24/-20):
    Btrfs: fix use-after-free when cloning a trailing file hole (+9/-11)
    Btrfs: atomically set inode->i_flags in btrfs_update_iflags (+10/-7)
    Btrfs: assert send doesn't attempt to start transactions (+4/-2)
    Btrfs: fix crash when starting transaction (+1/-0)

Liu Bo (2) commits (+4/-6):
    Btrfs: fix crash when mounting raid5 btrfs with missing disks (+3/-2)
    Btrfs: fix race of using total_bytes_pinned (+1/-4)

Josef Bacik (2) commits (+7/-5):
    btrfs: only unlock block in verify_parent_transid if we locked it (+2/-1)
    Btrfs: fix btrfs_print_leaf for skinny metadata (+5/-4)

David Sterba (2) commits (+1/-6):
    btrfs: remove stale comment from btrfs_flush_all_pending_stuffs (+0/-5)
    btrfs: use E2BIG instead of EIO if compression does not help (+1/-1)

Eric Sandeen (1) commits (+2/-1):
    btrfs: fix nossd and ssd_spread mount option regression

Sergey Senozhatsky (1) commits (+1/-1):
    btrfs compression: reuse recently used workspace

Wang Shilong (1) commits (+4/-0):
    Btrfs: fix race between balance recovery and root deletion

Total: (20) commits

 fs/btrfs/compression.c     |  2 +-
 fs/btrfs/dev-replace.c     |  5 +++++
 fs/btrfs/disk-io.c         |  5 ++++-
 fs/btrfs/extent-tree.c     |  5 +----
 fs/btrfs/ioctl.c           | 37 +++++++++++++++++++------------------
 fs/btrfs/print-tree.c      |  9 +++++----
 fs/btrfs/raid56.c          |  5 +++--
 fs/btrfs/super.c           |  7 ++++++-
 fs/btrfs/sysfs.c           | 32 +++++++++++++++++++++++++++++---
 fs/btrfs/sysfs.h           |  4 ++++
 fs/btrfs/transaction.c     | 12 +++++-------
 fs/btrfs/volumes.c         | 30 +++++++++++++++++++++++++-----
 fs/btrfs/zlib.c            |  2 +-
 include/uapi/linux/btrfs.h |  1 +
 14 files changed, 109 insertions(+), 47 deletions(-)
