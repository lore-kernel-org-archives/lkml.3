Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaHDOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:09:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34660 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaHDOJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:09:28 -0400
Date: Mon, 4 Aug 2014 16:09:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Edward Thornber <thornber@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/15] block copy: initial XCOPY offload support
Message-ID: <20140804140925.GA24261@amd.pavel.ucw.cz>
References: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1407151534180.14632@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1407151534180.14632@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-15 15:34:47, Mikulas Patocka wrote:
> This is Martin Petersen's xcopy patch
> (https://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=xcopy&id=0bdeed274e16b3038a851552188512071974eea8)
> with some bug fixes, ported to the current kernel.
> 
> This patch makes it possible to use the SCSI XCOPY command.
> 
> We create a bio that has REQ_COPY flag in bi_rw and a bi_copy structure
> that defines the source device. The target device is defined in the
> bi_bdev and bi_iter.bi_sector.
> 
> There is a new BLKCOPY ioctl that makes it possible to use XCOPY from
> userspace. The ioctl argument is a pointer to an array of four uint64_t
> values.

But it is there only for block devices, right?

Is there plan to enable tools such as /bin/cp to use XCOPY?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
