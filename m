Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbaIPTyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:54:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbaIPTyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:54:39 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/7] O_NONBLOCK flag for readv2/preadv2
References: <cover.1410810247.git.milosz@adfin.com>
	<ead00ff46b581749da6d1a6d2db9d8f8dc3aed67.1410810247.git.milosz@adfin.com>
	<x4961gnz844.fsf@segfault.boston.devel.redhat.com>
	<CANP1eJEiGxQ0fZMkOY1utmkUOkGC4gOHYrXt+yO-9+tnzA24hw@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Sep 2014 15:53:56 -0400
In-Reply-To: <CANP1eJEiGxQ0fZMkOY1utmkUOkGC4gOHYrXt+yO-9+tnzA24hw@mail.gmail.com>
	(Milosz Tanski's message of "Tue, 16 Sep 2014 15:44:13 -0400")
Message-ID: <x49ppevwdd7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

>> Why did you put the wouldblock label inside the loop?  That should be
>> pushed down to just above out, and then you can get rid of the goto.
>
> When I put the code outside the loop it actually looked worse (imo):
>
> }
>
> goto out;
>
> would_block:
> error = -EAGAIN;
>
> out:
> ...
>

We don't exit the loop without a return or a goto, so you wouldn't need
that 'goto out' just below the end of the loop.  It would look like:

	}

would_block:
	error = -EAGAIN;
out:
...

> Point taken and I can fix this for the next version further up the
> stack. A longer term question is how the flags the file is open with
> interact with the read/write flags ... since I imagine folks will want
> to add other flags (like force a SYNC write).

I think we'll have to address those one at a time.  I do like the idea
of the SYNC flag for a write, though you'll probably have several
variants of that (equivalents of SYNC and DSYNC at least).  Another fun
write flag to consider is O_ATOMIC.  :)

Cheers,
Jeff
