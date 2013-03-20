Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934275Ab3CTJPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:15:32 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:49984 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab3CTJP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:15:26 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130319212401.GJ21522@ZenIV.linux.org.uk>
References: <1363184193-1796-3-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1944.1363525619@warthog.procyon.org.uk>
	<20130318153936.GB28508@quack.suse.cz>
	<20130318215333.GE21522@ZenIV.linux.org.uk>
	<20130318230103.GF21522@ZenIV.linux.org.uk>
	<20130319013805.GG21522@ZenIV.linux.org.uk>
	<CAJfpegt8Zi3f5VxWc0kGRFcra3x_rze8j6dKCCTb4t+ViMCVYA@mail.gmail.com>
	<20130319170324.GI21522@ZenIV.linux.org.uk>
	<CAJfpeguXYY4Ldbuq+1YXRhZZ_pPhnRzM=hU1qhK=YqCmzbjXLQ@mail.gmail.com>
	<20130319212401.GJ21522@ZenIV.linux.org.uk>
Date: Wed, 20 Mar 2013 10:15:25 +0100
Message-ID: <CAJfpegssHT8s+hGf6mUV2fX0cxmU=R8gtjGLNxGz-WCyqXp=3Q@mail.gmail.com>
Subject: Re: [PATCH 2/9] vfs: export do_splice_direct() to modules
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 10:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> it still might make sense to implement
> something as a layer, but some parts of that sucker may be better off as
> fs primitives.  Hell, we could, in theory, implement xattrs as a layer;
> just look at how reiserfs had done them.  We could do the same for hardlinks
> (look at qnx4, if you wish to see that hack).  Of for symlinks (sysvfs).
> Or for opened-and-unlinked files (sillyrename could be done as a generic
> layer).  Or for permissions/ownership/arbitrary names (umsdos, and that
> _was_ very similar to layering).  It's just that often an underlying fs
> has a better way of doing that.  IMO whiteouts are in that class.

My gut feeling is that whiteouts (and all that's related) are just too
specialized.  All the examples you listed are more general purpose.

I know one that could be useful for a variety of things, an "exchange"
operation.   While similar to rename, the semantics are much cleaner
and so the implementation becomes easier as well.

But that one doesn't quite solve the rename-with-whiteout thing.   For
that a three way permutation would be needed where one of the three is
an unlinked "floating" object.   That one is a really generic op but
we'd need to introduce linking unlinked objects into the tree which
comes with its own problems.

But I think it may be worth trying to come up with something more
generally useful before adding whiteouts and various overlay-specific
flags to filesystem code.

Thanks,
Miklos
