Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab3HBODb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:03:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3HBODa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:03:30 -0400
Date: Fri, 2 Aug 2013 16:04:55 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Christie <michaelc@cs.wisc.edu>, Shaohua Li <shli@fusionio.com>
Subject: [PATCH 0/3] blk-mq: Avoid effects of a weird queue depth
Message-ID: <cover.1375451955.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This series aimed to avoid effects of a weird queue depth,
i.e when less than reserved_tags requested or insufficient
number of requests were allocated.

In case number of normal (not reserved) tags is requested
less than 4 (current minimal cache size limit) there are two
options to resolve: adjust cache size to the depth or deny
queue depths less than the minimal cache size. I favored the
latter, but will repost if you prefer otherwise.

Alexander Gordeev (3):
  blk-mq: Sanity check reserved tags
  blk-mq: Check queue depth is valid
  blk-mq: Do not allocate more cache entries than used

 block/blk-mq-tag.c |   31 ++++++++++++++++++-------------
 block/blk-mq-tag.h |    6 ++++++
 block/blk-mq.c     |   12 +++++++-----
 3 files changed, 31 insertions(+), 18 deletions(-)

-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
