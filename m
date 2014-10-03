Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbaJCJZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:25:40 -0400
Received: from smtp.ctxuk.citrix.com ([185.25.65.24]:8330 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaJCJZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:25:37 -0400
X-IronPort-AV: E=Sophos;i="5.04,645,1406592000"; 
   d="scan'208";a="25664478"
From: Thanos Makatos <thanos.makatos@citrix.com>
To: "'Jens Axboe'" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "jlayton@poochiereds.net" <jlayton@poochiereds.net>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "jack@suse.cz" <jack@suse.cz>
Subject: RE: [PATCH RFC] introduce ioctl to completely invalidate page cache
Thread-Topic: [PATCH RFC] introduce ioctl to completely invalidate page cache
Thread-Index: AQHP3ltJMeutIaA2t0eKb6z3ckY5/ZwdGI8AgAD/jRA=
Date: Fri, 3 Oct 2014 09:25:34 +0000
Message-ID: <2368A3FCF9F7214298E53C823B0A48EC0423DFE3@AMSPEX01CL02.citrite.net>
References: <1412266184-23776-1-git-send-email-thanos.makatos@citrix.com>
 <542DAEAC.8010203@kernel.dk>
In-Reply-To: <542DAEAC.8010203@kernel.dk>
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

> > -		fsync_bdev(bdev);
> > -		invalidate_bdev(bdev);
> > +		flush_buffer_cache(bdev);
> > +		if (BLKFLSBUF2 == cmd)
> > +			return invalidate_inode_pages2(
> > +					bdev->bd_inode->i_mapping);
> >  		return 0;
> 
> We're currently ignoring the buffer cache sync and invalidation (which is odd),
> but at least being consistent would be good.
> 
> Might also need a filemap_write_and_wait() to sync before invalidation.

(I've got zero knowledge in this area, so excuse my ignorance!)

Does filemap_write_and_wait() writes back modified, memory-mapped pages? If so, isn't there a race condition? Or have I got it completely wrong?
