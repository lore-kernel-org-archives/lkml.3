Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbaIPNpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:45:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbaIPNpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:45:40 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        michael.kerrisk@gmail.com
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
References: <cover.1410810247.git.milosz@adfin.com>
	<x49d2awr1ez.fsf@segfault.boston.devel.redhat.com>
	<CANP1eJF7b3RFd4NdyCfsFuf9uyhrahVqJkDHs81nd2ZvVDwzSg@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Sep 2014 09:44:57 -0400
In-Reply-To: <CANP1eJF7b3RFd4NdyCfsFuf9uyhrahVqJkDHs81nd2ZvVDwzSg@mail.gmail.com>
	(Milosz Tanski's message of "Mon, 15 Sep 2014 18:27:07 -0400")
Message-ID: <x49bnqf3ciu.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> writes:

> Jeff,
>
> This patchset creates a new read (readv2/preadv2) syscall(s) that take
> a extra flag argument (kind of like recvmsg). What it doesn't do is
> change the current behavior of of the O_NONBLOCK, if the file is
> open() with O_NONBLOCK flag. It shouldn't break any existing
> applications since you have to opt into using this by using the new
> syscall.

Hi, Milosz,

Ah, I misread one of the patches.  Now that I've applied the series, I
see that you're testing the flag argument, not the file open flags.

> I don't have a preference either way if we should create a new flag or
> re-use O_NONBLOCK the flag. Instead, I'm hoping to get some consensus
> here from senior kernel developers like yourself. Maybe a RWF_NONBLOCK
> (I'm stealing from eventfd, EFD_NONBLOCK).

I think I'd rather name the flag something other than O_NONBLOCK, if for
no other reason that to avoid confusion.

> As a side note, I noticed that EFD_NONBLOCK, SFD_NONBLOCK, etc... all
> alias to the value of O_NONBLOCK and there's a bunch of bug checks in
> the code like this:
> BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);

That's because the flag is passed on to anon_inode_getfile.  See also
this define:

#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)

A general note on your subjects -- you should make them more specific to
the subsystem you're updating.  Commit titles like "documentation
update" are a bit too broad.  ;-)

Cheers,
Jeff
