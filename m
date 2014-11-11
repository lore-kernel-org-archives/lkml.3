Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaKKWua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:50:30 -0500
Received: from imap.thunk.org ([74.207.234.97]:52424 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbaKKWu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:50:28 -0500
Date: Tue, 11 Nov 2014 17:49:38 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Milosz Tanski <milosz@adfin.com>, Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Message-ID: <20141111224938.GA4112@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Jeff Moyer <jmoyer@redhat.com>, Milosz Tanski <milosz@adfin.com>,
	Dave Chinner <david@fromorbit.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-aio@kvack.org" <linux-aio@kvack.org>,
	Mel Gorman <mgorman@suse.de>,
	Volker Lendecke <Volker.Lendecke@sernet.de>,
	Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Linux API <linux-api@vger.kernel.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	linux-arch@vger.kernel.org
References: <cover.1415636409.git.milosz@adfin.com>
 <20141111064417.GT23575@dastard>
 <CANP1eJHfWT0Foe+weB1SJkJ10JnOge_g=E8CXBsQNPW7i2+4NA@mail.gmail.com>
 <x49ioilbrfx.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ioilbrfx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 12:03:14PM -0500, Jeff Moyer wrote:
> 
> I think he's referring to xfstests.  Still, I think that's the wrong
> place for functional testing.  ltp would be better, imo.

I disagree; xfstests is the right place for adding these tests, because
these patches seem to require fs-specific support, and file system
developers are already using xfstests when checking for regressions.
Using xfstests is already part of most of the file system developers'
workflow; ltp is not. 

So if you want to make sure we notice regressions, it really needs to
go into xfstests.  If you insist on putting it in ltp, then one of us
will then have to make a copy of the tests and put it in xfstests.

Cheers,

						- Ted
