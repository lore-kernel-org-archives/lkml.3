Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaKKX2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 18:28:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:38468 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbaKKX2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 18:28:40 -0500
Date: Wed, 12 Nov 2014 00:27:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Jeff Moyer <jmoyer@redhat.com>, Milosz Tanski <milosz@adfin.com>,
        Dave Chinner <david@fromorbit.com>,
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
In-Reply-To: <20141111224938.GA4112@thunk.org>
Message-ID: <alpine.DEB.2.11.1411120017260.3935@nanos>
References: <cover.1415636409.git.milosz@adfin.com> <20141111064417.GT23575@dastard> <CANP1eJHfWT0Foe+weB1SJkJ10JnOge_g=E8CXBsQNPW7i2+4NA@mail.gmail.com> <x49ioilbrfx.fsf@segfault.boston.devel.redhat.com> <20141111224938.GA4112@thunk.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Theodore Ts'o wrote:
> On Tue, Nov 11, 2014 at 12:03:14PM -0500, Jeff Moyer wrote:
> > 
> > I think he's referring to xfstests.  Still, I think that's the wrong
> > place for functional testing.  ltp would be better, imo.
> 
> I disagree; xfstests is the right place for adding these tests, because
> these patches seem to require fs-specific support, and file system
> developers are already using xfstests when checking for regressions.
> Using xfstests is already part of most of the file system developers'
> workflow; ltp is not. 
> 
> So if you want to make sure we notice regressions, it really needs to
> go into xfstests.  If you insist on putting it in ltp, then one of us
> will then have to make a copy of the tests and put it in xfstests.

No. LTP needs to pull in the latest changes from xfstests simply
because LTP is a conglomerate of domain specific tests. And it never
can become more than a conglomerate for obvious reasons.

xfstests is what the FS developers use and update. If LTP has some
extra magic tests developed then is should send patches against
xfstests and reintegrate the result.

Thanks,

	tglx
