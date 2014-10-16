Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaJPHvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:51:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65264 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbaJPHvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:51:20 -0400
Message-ID: <543F78F1.6040203@fb.com>
Date: Thu, 16 Oct 2014 03:51:13 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [GIT PULL] Btrfs corruption fix
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-16_04:2014-10-15,2014-10-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=8.94047058608294e-11 kscore.compositescore=0
 circleOfTrustscore=28.9261618248808 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410160079
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I'm testing a pull with more fixes, but wanted to get this one out so
Greg can pick it up.  The corruption isn't easy to hit, you have to do a
readonly snapshot and have orphans in the snapshot.  But my review and
testing missed the bug.  Filipe has added a better xfstest to cover it.

Please pull:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Chris Mason (1) commits (+33/-36):
    Revert "Btrfs: race free update of commit root for ro snapshots"

Total: (1) commits (+33/-36)

 fs/btrfs/inode.c | 36 ------------------------------------
 fs/btrfs/ioctl.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 36 deletions(-)
