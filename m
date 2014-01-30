Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaA3T0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:26:07 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:43816 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaA3T0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:26:05 -0500
MIME-Version: 1.0
In-Reply-To: <1390956313.25542.64.camel@kjgkr>
References: <20140128224336.GF25989@kernel.dk>
	<20140128225229.GH25989@kernel.dk>
	<20140129110536.00ce3c9e580f747fd0f1d0e6@canb.auug.org.au>
	<1390956313.25542.64.camel@kjgkr>
Date: Thu, 30 Jan 2014 11:26:04 -0800
X-Google-Sender-Auth: J0MSbUznEJ3hxgDMkUYf9Df9SsY
Message-ID: <CA+55aFwYxdqf3EZNr_Z1EUADi4ExL8aZc_HCR-X6XRv1r223yQ@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO changes for 3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: jaegeuk.kim@samsung.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 4:45 PM, Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:
>
> In the case of f2fs, could you please check the following code changes?

So I ended up doing the merge differently wrt the f2fs_write_end_io() function.

As far as I can tell, we can just initialize the f2fs_sb_info directly
and unconditionally using the first bio_vec entry, giving us the
simpler

    struct f2fs_sb_info *sbi =
F2FS_SB(bio->bi_io_vec->bv_page->mapping->host->i_sb);

which is still ugly, but whatever. I'm not quite seeing why f2fs
doesn't just set bio->private to the superblock pointer and avoid this
whole complex and long pointer chasing, but there's probably some
reason.

Anyway, it compiles for me, and looks simpler than the alternate
resolutions, but maybe there is some reason I miss why you guys did it
the way you did. And while I could test that it compiles and looks
sane, I don't have a f2fs to actually *test* it on, and maybe I
screwed up royally.

I'll push it out once I've done the rest of the allmodconfig build-test.

                 Linus
