Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaJFJVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:21:21 -0400
Received: from smtp.ctxuk.citrix.com ([185.25.65.24]:13189 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaJFJVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:21:19 -0400
X-IronPort-AV: E=Sophos;i="5.04,663,1406592000"; 
   d="scan'208";a="25713122"
From: Thanos Makatos <thanos.makatos@citrix.com>
To: "'Jan Kara'" <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "jlayton@poochiereds.net" <jlayton@poochiereds.net>,
        "bfields@fieldses.org" <bfields@fieldses.org>
Subject: RE: [PATCH RFC] introduce ioctl to completely invalidate page cache
Thread-Topic: [PATCH RFC] introduce ioctl to completely invalidate page cache
Thread-Index: AQHP3ltJMeutIaA2t0eKb6z3ckY5/ZwdGI8AgAWCNICAADKhoA==
Date: Mon, 6 Oct 2014 09:21:17 +0000
Message-ID: <2368A3FCF9F7214298E53C823B0A48EC042405BC@AMSPEX01CL02.citrite.net>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk> <20141006080659.GA7526@quack.suse.cz>
In-Reply-To: <20141006080659.GA7526@quack.suse.cz>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DLP: AMS1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We're currently ignoring the buffer cache sync and invalidation (which
> > is odd), but at least being consistent would be good.
>   Well, invalidate_bdev() doesn't return anything. And
> invalidate_mapping_pages() inside invalidate_bdev() returns only number of
> invalidated pages. I don't think there's any value in returning that.
> 
> OTOH invalidate_inode_pages2() returns 0 / -EBUSY / other error when
> invalidation of some page fails so returning that seems useful.
> 
> > Might also need a filemap_write_and_wait() to sync before invalidation.
>   That's what fsync_bdev() is doing under the hoods. Sometimes I'm not sure
> whether all these wrappers are useful...

Indeed, fsync_bdev() does call filemap_write_and_wait() so I don't need to explicitly do that.

> 
> Trond also had a comment that if we extended the ioctl to work for all inodes
> (not just blkdev) and allowed some additional flags of what needs to be
> invalidated, the new ioctl would be also useful to NFS userspace - see Trond's
> email at
> 
> http://www.spinics.net/lists/linux-fsdevel/msg78917.html
> 
> and the following thread. I would prefer to cover that usecase when we are
> introducing new invalidation ioctl. Have you considered that Thanos?

Sure, though I don't really know how to do it. I'll start by looking at the code flow when someone does " echo 3 > /proc/sys/vm/drop_caches", unless you already have a rough idea how to do that.

Thanks
