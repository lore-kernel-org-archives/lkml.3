Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaA1Wwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:52:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38173 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbaA1Ww3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:52:29 -0500
Date: Tue, 28 Jan 2014 15:52:29 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Core block IO changes for 3.14
Message-ID: <20140128225229.GH25989@kernel.dk>
References: <20140128224336.GF25989@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128224336.GF25989@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28 2014, Jens Axboe wrote:
> Hi Linus,
> 
> This is the pull request for the core block IO changes for 3.14. The
> major piece in here is the immutable bio_ve series from Kent, the rest
> is fairly minor. It was supposed to go in last round, but various issues
> pushed it to this release instead. The pull request contains:
> 
> 
> - Various smaller blk-mq fixes from different folks. Nothing major here,
>   just minor fixes and cleanups.
> 
> - Fix for a memory leak in the error path in the block ioctl code from
>   Christian Engelmayer.
> 
> - Header export fix from CaiZhiyong.
> 
> - Finally the immutable biovec changes from Kent Overstreet. This
>   enables some nice future work on making arbitrarily sized bios
>   possible, and splitting more efficient. Related fixes to immutable
>   bio_vecs:
> 
>         - dm-cache immutable fixup from Mike Snitzer.
>         - btrfs immutable fixup from Muthu Kumar.
> 
> - bio-integrity fix from Nic Bellinger, which is also going to stable.
> 
> 
> Please pull! There will be a bit of merge work for you, but it should be
> fairly straight forward. It's mostly related to changin:
> 
> bio->bi_sector  -> bio->bi_iter.bi_sector
> bio->bi_size    -> bio->bi_iter.bi_size
> 
> 
> git://git.kernel.dk/linux-block.git for-3.14/core

BTW, let me know if you want me to merge this. The above has been in
for-next since forever, and Stephen has carried a fix or two for new
merges.


-- 
Jens Axboe

