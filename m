Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab3APJmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:42:16 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36282
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758217Ab3APJmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:42:14 -0500
Date: Wed, 16 Jan 2013 10:41:57 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Shaohua Li <shli@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [madvise]  kernel BUG at block/blk-core.c:2981!
Message-ID: <20130116094157.GC12099@kernel.dk>
References: <20130116085434.GA18963@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116085434.GA18963@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16 2013, Fengguang Wu wrote:
> Shaohua,
> 
> I tried bisect and 0d18d770b9180ffc2c3f63b9eb8406ef80105e05 is the first bad commit.
> 
> commit 0d18d770b9180ffc2c3f63b9eb8406ef80105e05
> Author: Shaohua Li <shli@kernel.org>
> Date:   Sat Jan 12 10:56:05 2013 +1100
> 
>     mm: make madvise(MADV_WILLNEED) support swap file prefetch
> 
>     Make madvise(MADV_WILLNEED) support swap file prefetch.  If memory is
>     swapout, this syscall can do swapin prefetch.  It has no impact if the
>     memory isn't swapout.
> 
>     Signed-off-by: Shaohua Li <shli@fusionio.com>
>     Cc: Hugh Dickins <hughd@google.com>
>     Cc: Rik van Riel <riel@redhat.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Unbalanced path in that patch, see this patch:

https://patchwork.kernel.org/patch/1973481/

-- 
Jens Axboe

