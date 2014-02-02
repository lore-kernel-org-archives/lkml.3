Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaBBPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 10:16:29 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:53541 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaBBPQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 10:16:28 -0500
Date: Sun, 2 Feb 2014 08:16:24 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RESEND 0/10] fs: Introduce new
	flag(FALLOC_FL_COLLAPSE_RANGE) for fallocate
Message-ID: <20140202151624.GK20939@parisc-linux.org>
References: <1391319694-3089-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391319694-3089-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 02:41:34PM +0900, Namjae Jeon wrote:
> The semantics of this flag are following:
> 1) It collapses the range lying between offset and length by removing any data
>    blocks which are present in this range and than updates all the logical
>    offsets of extents beyond "offset + len" to nullify the hole created by
>    removing blocks. In short, it does not leave a hole.
> 2) It should be used exclusively. No other fallocate flag in combination.
> 3) Offset and length supplied to fallocate should be fs block size aligned
>    in case of xfs and ext4.
> 4) Collaspe range does not work beyond i_size.

What if the file is mmaped at the time somebody issues this command?
Seems to me we should drop pagecache pages that overlap with the
removed blocks.  If the removed range is not a multiple of PAGE_SIZE,
then we should also drop any pagecache pages after the removed range.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
