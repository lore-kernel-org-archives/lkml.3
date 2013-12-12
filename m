Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3LLV5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:57:12 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4144 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab3LLV5H convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:57:07 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Message-ID: <20131212215704.23771.16640@ret.masoncoding.com>
From: Chris Mason <clm@fb.com>
User-Agent: alot/0.3.5
Subject: [GIT PULL] Btrfs
Date: Thu, 12 Dec 2013 16:57:04 -0500
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2013-12-12_05:2013-12-12,2013-12-12,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull my for-linus branch (or for-linus signed tag):

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

This is a small collection of fixes.  It was rebased this morning, but I
was just fixing signed-off-by tags with the wrong email.

Wang Shilong (3) commits (+57/-24):
    Btrfs: skip building backref tree for uuid and quota tree when doing balance relocation (+3/-1)
    Btrfs: make sure we cleanup all reloc roots if error happens (+7/-0)
    Btrfs: fix an oops when doing balance relocation (+47/-23)

Filipe David Borba Manana (1) commits (+10/-12):
    Btrfs: don't miss skinny extent items on delayed ref head contention

Dan Carpenter (1) commits (+2/-2):
    Btrfs: fix access_ok() check in btrfs_ioctl_send()

Miao Xie (1) commits (+2/-3):
    Btrfs: don't clear the default compression type

David Sterba (1) commits (+2/-1):
    btrfs: call mnt_drop_write after interrupted subvol deletion

Total: (7) commits (+73/-42)

 fs/btrfs/extent-tree.c | 22 +++++++-------
 fs/btrfs/ioctl.c       |  3 +-
 fs/btrfs/relocation.c  | 81 +++++++++++++++++++++++++++++++++++---------------
 fs/btrfs/send.c        |  4 +--
 fs/btrfs/super.c       |  5 ++--
 5 files changed, 73 insertions(+), 42 deletions(-)
