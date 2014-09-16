Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbaIPVEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:04:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55754 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbaIPVEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:04:43 -0400
Date: Tue, 16 Sep 2014 14:04:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
Message-ID: <20140916210441.GC24591@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com>
 <x49wq93xt5e.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49wq93xt5e.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 03:27:41PM -0400, Jeff Moyer wrote:
> Christoph Hellwig <milosz@adfin.com> writes:
> 
> Hrm, you're not Christoph...
> 
> > Acked-by: Milosz Tanski <milosz@adfin.com>
> > ---
> >  fs/ceph/file.c    |    2 ++
> >  fs/cifs/file.c    |    6 ++++++
> >  fs/nfs/file.c     |    5 ++++-
> >  fs/ocfs2/file.c   |    6 ++++++
> >  fs/pipe.c         |    3 ++-
> >  fs/read_write.c   |   17 +++++++++++------
> >  fs/xfs/xfs_file.c |    4 ++++
> >  mm/shmem.c        |    4 ++++
> >  8 files changed, 39 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 4776257..b62e3a5 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -808,6 +808,8 @@ again:
> >  	if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
> >  	    (iocb->ki_filp->f_flags & O_DIRECT) ||
> >  	    (fi->flags & CEPH_F_SYNC)) {
> > +		if (flags & O_NONBLOCK)
> > +			return -EAGAIN;
> 
> Again, the right return value for the O_DIRECT case is EINVAL.

Is it?  We define -EAGAIN as it would block, which is defintively true
for O_DIRECT reads.
