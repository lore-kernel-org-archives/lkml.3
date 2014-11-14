Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161264AbaKNQwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:52:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965580AbaKNQwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:52:18 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Jones <davej@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Milosz Tanski <milosz@adfin.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-api@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
	<x49mw7tyc7e.fsf@segfault.boston.devel.redhat.com>
	<20141114163912.GA23769@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 14 Nov 2014 11:51:31 -0500
In-Reply-To: <20141114163912.GA23769@redhat.com> (Dave Jones's message of
	"Fri, 14 Nov 2014 11:39:12 -0500")
Message-ID: <x491tp5ybcc.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Fri, Nov 14, 2014 at 11:32:53AM -0500, Jeff Moyer wrote:
>
>  > > Can you write a test (or set of) for fstests that exercises this new
>  > > functionality? I'm not worried about performance, just
>  > > correctness....
>  > 
>  > On the subject of testing, I added support to trinity (attached,
>  > untested).  That did raise one question.  Do we expect applications to
>  > #include <linux/fs.h> to get the RWF_NONBLOCK definition?
>  
> Trinity will at least need an addition to include/compat.h for
> older headers that won't have the definition.  Looks ok otherwise.

OK, I'll add that.

> Also, I usually sit on stuff like this until the syscall numbers are
> in Linus tree. This is 3.19 stuff I presume ?
> istr akpm picked up execveat recently, so if that goes in first, we'll
> need to respin this anyway..

Sure.  I just wanted to test with trinity *before* it makes it into the
kernel.  Crazy, I know.  ;-)

Cheers,
Jeff
