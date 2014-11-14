Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161538AbaKNSpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:45:09 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:57651 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbaKNSpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:45:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141114163912.GA23769@redhat.com>
References: <cover.1415636409.git.milosz@adfin.com>
	<20141111064417.GT23575@dastard>
	<x49mw7tyc7e.fsf@segfault.boston.devel.redhat.com>
	<20141114163912.GA23769@redhat.com>
Date: Fri, 14 Nov 2014 13:45:02 -0500
Message-ID: <CANP1eJH6BNiJ8zwA2Ba4Dc-2NZ5s2TBE4NVg3Ydk_cvSdDQUFQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Dave Jones <davej@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Milosz Tanski <milosz@adfin.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 11:39 AM, Dave Jones <davej@redhat.com> wrote:
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
>
> Also, I usually sit on stuff like this until the syscall numbers are
> in Linus tree. This is 3.19 stuff I presume ?
> istr akpm picked up execveat recently, so if that goes in first, we'll
> need to respin this anyway..

Yes, I am hoping to get it into 3.19. It's a large pain having to deal
with other changes to the syscall code.

On a unrelated note I just back to figuring out how to add this to
xfstests. I got busy with other things the last few days. I'm still
not quite sure how to write a test using the framework, the
documentation (README) seams very XFS specific and otherwise the test
seam to be be split between many different files / directories / C
code / shell code. I might be me being slow... but it's just not
obvious for me how to glue the whole thing together.

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
