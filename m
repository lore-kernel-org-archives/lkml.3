Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaLOQmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:42:32 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50432 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750755AbaLOQm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:42:29 -0500
Date: Mon, 15 Dec 2014 09:42:21 -0700
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <jack@suse.cz>
Subject: [GIT PULL] Single revert/fix for core block bits for 3.19
Message-ID: <20141215164221.GA9270@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-15_03:2014-12-15,2014-12-15,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=3 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412150161
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Jan reported a problem this morning with a crash in blk-mq, and after
looking over the recent changes, it's obvious that the blk-mq-tag
waitqueue handling change is buggy. We could end up _not_ doing
finish_wait() before switching to a new waitqueue, thus corrupting the
wait task list.

Please pull this one revert of the problematic change, thanks!

  git://git.kernel.dk/linux-block.git for-linus

for you to fetch changes up to 35d37c66356eed46700e0d5db87211844d43a241:

  Revert "blk-mq: Micro-optimize bt_get()" (2014-12-15 08:30:26 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Revert "blk-mq: Micro-optimize bt_get()"

 block/blk-mq-tag.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

-- 
Jens Axboe

