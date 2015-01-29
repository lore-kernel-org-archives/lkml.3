Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761679AbbA2KDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:03:17 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:52400 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756415AbbA2KDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:03:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [RESEND] [PATCH] block: create ioctl to discard-or-zeroout a range of blocks
Date: Thu, 29 Jan 2015 11:02:58 +0100
Message-ID: <2747023.BlTyJ4fNVf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150129020025.GE9981@birch.djwong.org>
References: <20150129020025.GE9981@birch.djwong.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:1t06EFNA5IyIwZy+nZQCCElnMfWN3HmcjiGZmV4MH32ZTsk6T71
 Ob/0+0MsTXzfMmPmIMjHNWB4stE+16xe277OqWXkJaIz3anZRz4kTbysDXZIz6umayWRoFZ
 b06nlfq1ldTbPIrZjjV2qHxF+xogdQzeiC7kscpKGSTe+FNnlgQI4ooD6cn1I1BQV07TB+w
 FTwV7wzpS97lndDq5UZLA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 January 2015 18:00:25 Darrick J. Wong wrote:
> Create a new ioctl to expose the block layer's newfound ability to
> issue either a zeroing discard, a WRITE SAME with a zero page, or a
> regular write with the zero page.  This BLKZEROOUT2 ioctl takes
> {start, length, flags} as parameters.  So far, the only flag available
> is to enable the zeroing discard part -- without it, the call invokes
> the old BLKZEROOUT behavior.  start and length have the same meaning
> as in BLKZEROOUT.
> 
> Furthermore, because BLKZEROOUT2 issues commands directly to the
> storage device, we must invalidate the page cache (as a regular
> O_DIRECT write would do) to avoid returning stale cache contents at a
> later time.
> 
> This patch depends on "block: Add discard flag to
> blkdev_issue_zeroout() function" in Jens' for-3.20/core branch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 

Would this work ok for devices that fill discarded areas with all-ones
instead of all-zeroes? I believe SD cards can do either.

	Arnd
