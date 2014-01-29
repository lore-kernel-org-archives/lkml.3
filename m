Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaA2PkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:40:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaA2PkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:40:20 -0500
Date: Wed, 29 Jan 2014 08:40:14 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [GIT PULL] Core block IO changes for 3.14
Message-ID: <20140129154014.GP25989@kernel.dk>
References: <20140128224336.GF25989@kernel.dk>
 <20140128225229.GH25989@kernel.dk>
 <CAMuHMdUseSC+Roa5sTYfXtBxGn2OOCQpLAtdRgeoVAVdBrotWw@mail.gmail.com>
 <20140129151710.GO25989@kernel.dk>
 <CAMuHMdWdvSUV6-nWQ5w5TAYhSQBm20ruhaDj9y08jd5EMo=yGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWdvSUV6-nWQ5w5TAYhSQBm20ruhaDj9y08jd5EMo=yGA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29 2014, Geert Uytterhoeven wrote:
> Hi Jens,
> 
> On Wed, Jan 29, 2014 at 4:17 PM, Jens Axboe <axboe@kernel.dk> wrote:
> > On Wed, Jan 29 2014, Geert Uytterhoeven wrote:
> >> On Tue, Jan 28, 2014 at 11:52 PM, Jens Axboe <axboe@kernel.dk> wrote:
> >> >> - Finally the immutable biovec changes from Kent Overstreet. This
> >> >>   enables some nice future work on making arbitrarily sized bios
> >> >>   possible, and splitting more efficient. Related fixes to immutable
> >> >>   bio_vecs:
> >> >>
> >> >>         - dm-cache immutable fixup from Mike Snitzer.
> >> >>         - btrfs immutable fixup from Muthu Kumar.
> >> >>
> >> >> - bio-integrity fix from Nic Bellinger, which is also going to stable.
> >> >>
> >> >>
> >> >> Please pull! There will be a bit of merge work for you, but it should be
> >> >> fairly straight forward. It's mostly related to changin:
> >> >>
> >> >> bio->bi_sector  -> bio->bi_iter.bi_sector
> >> >> bio->bi_size    -> bio->bi_iter.bi_size
> >> >>
> >> >>
> >> >> git://git.kernel.dk/linux-block.git for-3.14/core
> >> >
> >> > BTW, let me know if you want me to merge this. The above has been in
> >> > for-next since forever, and Stephen has carried a fix or two for new
> >> > merges.
> >>
> >> arch/xtensa/platforms/iss/simdisk.c:108:23: error: 'struct bio' has no
> >> member named 'bi_sector'
> >>
> >> http://kisskb.ellerman.id.au/kisskb/buildresult/10542666/
> >
> > Does the below fix it for you? There's an existing bug in there where it
> > kunmaps the wrong part (page instead of the address). Not sure that
> > matters on xtensa or whether the kmaps are a no-op, but cleaned up none
> > the less.
> 
> Yes, it does. Thanks!

Thanks for testing!

> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Added.

Linus, I queued up this patch, it's in for-3.14/core as well. This will
offset the inserted/deleted lines by 7/7.

-- 
Jens Axboe

