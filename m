Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbaAQRkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:40:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbaAQRkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:40:32 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matias Bjorling <m@bjorling.me>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Sumanth <sumantk2@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH]  fs null_blk: Null pointer deference problem in alloc_page_buffers
References: <1389950530-8903-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 17 Jan 2014 12:39:58 -0500
In-Reply-To: <1389950530-8903-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	(Raghavendra K. T.'s message of "Fri, 17 Jan 2014 14:52:10 +0530")
Message-ID: <x49sismzevl.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> writes:

> diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
> index a2e69d2..6b0e049 100644
> --- a/drivers/block/null_blk.c
> +++ b/drivers/block/null_blk.c
> @@ -535,6 +535,11 @@ static int null_add_dev(void)
>  	if (!nullb)
>  		return -ENOMEM;
>  
> +	if (bs > PAGE_SIZE) {
> +		WARN(1, "Invalid block size. Setting it to 4096\n");
> +		bs = 4096;
> +	}
> +

Why are you hard-coding 4k instead of just using PAGE_SIZE?

Cheers,
Jeff
