Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaCaWcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 18:32:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaCaWce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 18:32:34 -0400
Date: Mon, 31 Mar 2014 15:32:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Conrad Meyer <cse.cem@gmail.com>
Cc: Conrad Meyer <cemeyer@uw.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark <markk@clara.co.uk>
Subject: Re: [PATCH v2] fs: FAT: Add support for DOS 1.x formatted volumes
Message-Id: <20140331153232.1ea27e25cb4690e64da63782@linux-foundation.org>
In-Reply-To: <CAG6CVpV6sxOc2ZH_xWRGc28N6W+M9iK6QbX-4bx326FON8B9GA@mail.gmail.com>
References: <1396120235-27844-1-git-send-email-cse.cem@gmail.com>
	<20140331151337.f6a46a8fcab6206f4d21be08@linux-foundation.org>
	<CAG6CVpV6sxOc2ZH_xWRGc28N6W+M9iK6QbX-4bx326FON8B9GA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 15:21:17 -0700 Conrad Meyer <cse.cem@gmail.com> wrote:

> >> +     if (get_unaligned_le16(&b->sector_size) != 0 || b->sec_per_clus != 0 ||
> >> +             b->reserved != 0 || b->fats != 0 ||
> >> +             get_unaligned_le16(&b->dir_entries) != 0 ||
> >> +             get_unaligned_le16(&b->sectors) != 0 || b->media != 0 ||
> >> +             b->fat_length != 0 || b->secs_track != 0 || b->heads != 0 ||
> >> +             b->secs_track != 0 || b->heads != 0)
> >
> > Impressive!
> 
> I aim to please.

No great improvements immediately occur to me ;)

One could do

	/* nice comment */
	if (get_unaligned_le16(&b->sector_size) != 0)
		return;
	/* another nice comment */
	if (b->sec_per_clus != 0)
		return;
	...

but one would quickly run out of nice comments.

You could do s/ != 0//g.

> Not sure what would be better -- memcmp() part of the
> struct to a zeroed array?

memcmp would be hacky.  And possibly buggy if there are holes in the
struct, which is arch-dependent, shudder.

