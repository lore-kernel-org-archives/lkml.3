Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab3JKID6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:03:58 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:65140 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3JKID1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:03:27 -0400
X-AuditID: 9c930179-b7c78ae000003065-42-5257b0ceaf77
Date: Fri, 11 Oct 2013 17:03:29 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Squashfs: Directly decompress into the page cache
 for file data
Message-ID: <20131011080329.GE6847@bbox>
References: <1381472381-3825-1-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381472381-3825-1-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Phillip,

I looked at the patchset roughly and I feel it's really awesome
so I have to rebase decompressor_multi.c on it. 
But before that, could you review it?
I think you may have some stuff to hate like naming and even more.

Thanks.

On Fri, Oct 11, 2013 at 07:19:37AM +0100, Phillip Lougher wrote:
> This patch-set introduces an implementation of
> squashfs_readpage() that directly decompresses into the
> page cache.
> 
> It first generalises the decompressors by adding a page handler
> abstraction.  This adds helpers to allow the decompressors
> to access and process the output buffers in an implementation
> independant manner.
> 
> It then adds a read_page() implementation for file data that
> uses the page handler abstraction to push down the necessary
> kmap_atomic/kunmap_atomic operations on the page cache buffers into
> the decompressors.  This enables direct copying into the page cache
> without using the slow kmap/kunmap calls.
> 
> The code detects when multiple threads are racing in
> squashfs_readpage() to decompress the same block, and avoids
> this regression by falling back to using an intermediate
> buffer.
> 
> This patch enhances the performance of Squashfs significantly
> when multiple processes are accessing the filesystem simultaneously
> because it not only reduces memcopying, but it more importantly
> eliminates the lock contention on the intermediate buffer.
> 
> Using single-threaded decompression.
> 
>         dd if=file1 of=/dev/null bs=4096 &
>         dd if=file2 of=/dev/null bs=4096 &
>         dd if=file3 of=/dev/null bs=4096 &
>         dd if=file4 of=/dev/null bs=4096
> 
> Before:
> 
> 629145600 bytes (629 MB) copied, 45.8046 s, 13.7 MB/s
> 
> After:
> 
> 629145600 bytes (629 MB) copied, 9.29414 s, 67.7 MB/s
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
