Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaIJTU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:20:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52476 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIJTU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:20:57 -0400
Date: Wed, 10 Sep 2014 20:20:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 08/12] nfs: convert lock handling to use
 file_lock_context
Message-ID: <20140910192052.GB7996@ZenIV.linux.org.uk>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
 <1410359330-27564-9-git-send-email-jlayton@primarydata.com>
 <20140910191734.GD4210@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910191734.GD4210@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 03:17:34PM -0400, J. Bruce Fields wrote:
> On Wed, Sep 10, 2014 at 10:28:46AM -0400, Jeff Layton wrote:
> > Signed-off-by: Jeff Layton <jlayton@primarydata.com>
> > ---
> >  fs/nfs/delegation.c | 37 +++++++++++++++++++++----------------
> >  fs/nfs/nfs4state.c  | 24 +++++++++++++++---------
> >  fs/nfs/pagelist.c   |  3 ++-
> >  fs/nfs/write.c      | 39 +++++++++++++++++++++++++++++++++------
> >  4 files changed, 71 insertions(+), 32 deletions(-)
> > 
> > diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
> > index 5853f53db732..22c6eed9bb5b 100644
> > --- a/fs/nfs/delegation.c
> > +++ b/fs/nfs/delegation.c
> > @@ -85,25 +85,30 @@ static int nfs_delegation_claim_locks(struct nfs_open_context *ctx, struct nfs4_
> >  {
> >  	struct inode *inode = state->inode;
> >  	struct file_lock *fl;
> > +	struct file_lock_context *flctx = inode->i_flctx;

Ummm...  Something ought to be done for inflicting identifiers like that on
those who'll read that code.  But That Would Probably Be Illegal(tm), more's
the pity...
