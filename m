Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaAVEWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:22:25 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45021 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaAVEWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:22:22 -0500
Date: Tue, 21 Jan 2014 20:22:09 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matias Bjorling <m@bjorling.me>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Jeff <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH V3 1/2]  null_blk: Null pointer deference problem in
 alloc_page_buffers
Message-ID: <20140122042209.GF20347@kernel.dk>
References: <1390303800-22422-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <1390303800-22422-2-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390303800-22422-2-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21 2014, Raghavendra K T wrote:
>  If we load the null_blk module with bs=8k we get following oops:
> [ 3819.812190] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> [ 3819.812387] IP: [<ffffffff81170aa5>] create_empty_buffers+0x28/0xaf
> [ 3819.812527] PGD 219244067 PUD 215a06067 PMD 0
> [ 3819.812640] Oops: 0000 [#1] SMP
> [ 3819.812772] Modules linked in: null_blk(+)
> 
>  Fix that by resetting block size to PAGE_SIZE if it is greater than PAGE_SIZE

Thanks, applied.

-- 
Jens Axboe

