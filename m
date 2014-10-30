Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbaJ3ETG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 00:19:06 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:43729 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756565AbaJ3ETD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 00:19:03 -0400
MIME-Version: 1.0
In-Reply-To: <yq1bnoukzhe.fsf@sermon.lab.mkp.net>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
	<yq1k33il3b3.fsf@sermon.lab.mkp.net>
	<5451A3F5.9020903@fb.com>
	<yq1bnoukzhe.fsf@sermon.lab.mkp.net>
Date: Wed, 29 Oct 2014 21:19:02 -0700
Message-ID: <CAPcyv4ggAXzWows0PayvspOX4aP9G0PmLDes+0Q+m6VXQcF9Mw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Enable use of Solid State Hybrid Drives
From: Dan Williams <dan.j.williams@intel.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@fb.com>, "Jason B. Akers" <jason.b.akers@intel.com>,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        "Karkra, Kapil" <kapil.karkra@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 8:28 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> The next step was trying to map these hints into what was available in
> xadvise(), NFS 4.2 and the recent T10/T13 efforts. That wasn't trivial
> and there really isn't a 1:1 mapping that works. So I went to T10 and
> tried to nudge things in the same direction as NFS 4.2. Mainly because
> that's closer to what we already have in xadvise().

In case you still have hair left to pull wrangling these multiple
specifications, Matthew reminds me that NVME also has cache advice at
the transport layer.

> Jens> I think we've needed a proper API for passing in appropriate hints
> Jens> on a per-io basis for a LONG time.
>
> Yup.

I understand the desire to have per-io / per-inode xadvise()-style
hints, but I don't see why not also include a per-pid capability?

Per-pid was not "icky" for flashcache [1].  It let's you flag
processes that should not pollute the cache, as well "cache warming"
processes pre-loading sub-ranges of files that is awkward to do with a
per-inode hint.  Per-pid also allows hinting on behalf of other
otherwise cache-unaware processes.

> Jens> That is the big challenge. We've tried (and failed) in the past to
> Jens> define a set of hints that make sense. It'd be a shame to add
> Jens> something that's specific to a given transport/technology.
>
> Absolutely!

In this RFC we end up punting the ultimate kernel-to-transport hint
translation to userspace.  The kernel has a default interpretation,
but it seems it will almost always be inadequate trying to account for
per-device-quirks and platform performance policies.

[1]: https://github.com/facebook/flashcache/blob/master/doc/flashcache-doc.txt#L139
