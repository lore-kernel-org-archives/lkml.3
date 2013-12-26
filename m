Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3LZJCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 04:02:10 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44025 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3LZJCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 04:02:07 -0500
Date: Thu, 26 Dec 2013 01:02:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jeff Mahoney <jeffm@suse.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1] reiserfs:Adding tmpfile support
Message-ID: <20131226090203.GA17995@infradead.org>
References: <20131225142340.92120e3c3d9a98858db79748@skynet.be>
 <CAFLxGvx1m_HL7wPA1=LXpjJvwN7oMCKjxJk4AHO+cgQW0FPf+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvx1m_HL7wPA1=LXpjJvwN7oMCKjxJk4AHO+cgQW0FPf+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 25, 2013 at 02:39:48PM +0100, Richard Weinberger wrote:
> On Wed, Dec 25, 2013 at 2:23 PM, Fabian Frederick <fabf@skynet.be> wrote:
> > This patch is largely based on reiserfs_create function.
> > -Removing dquot_initialize (cf ext2/tmpfile)
> > -Removing add_entry code.
> > -Adding d_tmpfile generic call.
> >
> > It was not extensively tested; other solutions would
> > be to work with hidden entries or merge
> > creation - tmpfile process.
> 
> Is it worth adding new features to a legacy file system like reiserfs?

Having user API parity is always a good thing, especially if it doesn't
require on-disk format changes.  Same case as FIEMAP or
SEEK_DATA/SEEK_HOLE to mention some recent features.

That being said this needs to follow them model of ext3/ext3/xfs and
add the inode to the unlink/orphan inode list on tmpfile creation and
move it out on flink.

We'll also need a proper verifier for the expected behaviour, which I
hope we'll get out of the work in progress XFS support.
