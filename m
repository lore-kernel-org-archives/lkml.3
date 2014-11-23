Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaKWPRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:17:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11885 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751237AbaKWPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:17:07 -0500
Date: Sun, 23 Nov 2014 10:14:45 -0500
From: Chris Mason <clm@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Btrfs deadlock fix
Message-ID: <20141123151439.GA16816@ret.masoncoding.com>
Mail-Followup-To: Chris Mason <clm@fb.com>, torvalds@linux-foundation.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-23_02:2014-11-21,2014-11-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.65423230669148e-14 kscore.compositescore=0
 circleOfTrustscore=28.9261618248808 compositescore=0.939076664828693
 urlsuspect_oldscore=0.939076664828693 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.939076664828693 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1411230127
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

My for-linus branch:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus

Has a fix for a long standing deadlock that we've been trying to nail
down for a while.  It ended up being a bad interaction with the fair
reader/writer locks and the order btrfs reacquires locks in the btree.

Chris Mason (1) commits (+25/-15):
    btrfs: fix lockups from btrfs_clear_path_blocking

Total: (1) commits (+25/-15)

 fs/btrfs/ctree.c   | 14 ++------------
 fs/btrfs/locking.c | 24 +++++++++++++++++++++---
 fs/btrfs/locking.h |  2 ++
 3 files changed, 25 insertions(+), 15 deletions(-)
