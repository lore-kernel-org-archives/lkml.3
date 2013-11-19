Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3KSIHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:07:12 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45559 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3KSIHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:07:09 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-f4-528b1c2c315b
Date: Tue, 19 Nov 2013 17:07:33 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Squashfs: Refactor decompressor interface and code
 (V3)
Message-ID: <20131119080733.GV4407@bbox>
References: <1384406059-28567-1-git-send-email-phillip@squashfs.org.uk>
 <1384406059-28567-2-git-send-email-phillip@squashfs.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384406059-28567-2-git-send-email-phillip@squashfs.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 14, 2013 at 05:14:16AM +0000, Phillip Lougher wrote:
> The decompressor interface and code was written from
> the point of view of single-threaded operation.  In doing
> so it mixed a lot of single-threaded implementation specific
> aspects into the decompressor code and elsewhere which makes it
> difficult to seamlessly support multiple different decompressor
> implementations.
> 
> This patch does the following:
> 
> 1.  It removes compressor_options parsing from the decompressor
>     init() function.  This allows the decompressor init() function
>     to be dynamically called to instantiate multiple decompressors,
>     without the compressor options needing to be read and parsed each
>     time.
> 
> 2.  It moves threading and all sleeping operations out of the
>     decompressors.  In doing so, it makes the decompressors
>     non-blocking wrappers which only deal with interfacing with
>     the decompressor implementation.
> 
> 3. It splits decompressor.[ch] into decompressor generic functions
>    in decompressor.[ch], and moves the single threaded
>    decompressor implementation into decompressor_single.c.
> 
> The result of this patch is Squashfs should now be able to
> support multiple decompressors by adding new decompressor_xxx.c
> files with specialised implementations of the functions in
> decompressor_single.c
> 
> V3:
>   * decompressor_single.c: Remove kfree(comp_opts) in error path
>   * of squashfs_decompressor_create()
>   * Double free of comp_opts found by static analysis, reported by
>   * Dan Carpenter
> 
> Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reviewed-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
