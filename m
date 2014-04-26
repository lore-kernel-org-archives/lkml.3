Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaDZXbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 19:31:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41569 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716AbaDZXbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 19:31:16 -0400
Message-ID: <535C41EA.5070408@fb.com>
Date: Sat, 26 Apr 2014 19:31:54 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-26_02:2014-04-25,2014-04-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=9.57273149637672e-12 kscore.compositescore=0
 circleOfTrustscore=28.9261618248808 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1404260392
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull these fixes from my for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Wang Shilong (3) commits (+24/-20):
    Btrfs: avoid triggering bug_on() when we fail to start inode caching task (+5/-1)
    Btrfs: move btrfs_{set,clear}_and_info() to ctree.h (+14/-14)
    Btrfs: fix possible memory leaks in open_ctree() (+5/-5)

Filipe Manana (2) commits (+5/-1):
    Btrfs: use correct key when repeating search for extent item (+2/-0)
    Btrfs: correctly set profile flags on seqlock retry (+3/-1)

Christoph Jaeger (1) commits (+6/-2):
    btrfs: fix use-after-free in mount_subvol()

Chris Mason (1) commits (+5/-0):
    Btrfs: limit the path size in send to PATH_MAX

Qu Wenruo (1) commits (+1/-1):
    btrfs: Change the hole range to a more accurate value.

David Sterba (1) commits (+5/-5):
    btrfs: replace error code from btrfs_drop_extents

Miao Xie (1) commits (+2/-16):
    Btrfs: fix inode caching vs tree log

Total: (10) commits (+48/-45)

 fs/btrfs/ctree.h       | 14 ++++++++++++++
 fs/btrfs/disk-io.c     | 10 +++++-----
 fs/btrfs/extent-tree.c |  6 +++++-
 fs/btrfs/file.c        |  8 ++++----
 fs/btrfs/inode-map.c   | 24 +++++++-----------------
 fs/btrfs/ioctl.c       |  4 ++--
 fs/btrfs/send.c        |  5 +++++
 fs/btrfs/super.c       | 22 ++++++----------------
 8 files changed, 48 insertions(+), 45 deletions(-)
