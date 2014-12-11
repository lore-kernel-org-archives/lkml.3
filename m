Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbaLKSG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:06:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44471 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaLKSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:06:28 -0500
Date: Thu, 11 Dec 2014 18:06:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [GIT PULL] vfs.git
Message-ID: <20141211180624.GX22149@ZenIV.linux.org.uk>
References: <20141210191302.GO22149@ZenIV.linux.org.uk>
 <CAELBmZDLTOskhHaZEMOPA8n9VgAcr0cJvqYjx=YADpx_=mYQcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAELBmZDLTOskhHaZEMOPA8n9VgAcr0cJvqYjx=YADpx_=mYQcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 05:18:21PM +0100, Miklos Szeredi wrote:
> On Wed, Dec 10, 2014 at 8:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> >         * killing a bunch of ->f_path.dentry users (and f_dentry macro).
> > Getting that completed will make life much simpler for unionmount/overlayfs,
> > since then we'll be able to limit the places sensitive to file _dentry_
> > to reasonably few.  Which allows to have file_inode(file) pointing to
> > inode in a covered layer, with dentry pointing to (negative) dentry in
> > union one.  Still not complete, but much closer now.
> 
> If we want f_path to point to union path, then shouldn't we be hiding
> it from all but core VFS?  Filesystems have no business looking at the
> mount anyway.  And looking at the union dentry will be just an endless
> source of bugs.
>
> Also some API changes are in order, like passing dentry to ->iterate()
> for "readdirplus" like operations, since f_path.dentry won't be usable
> for that purpose.  Alternatively replace f_inode with f_dentry and
> make file_inode() use that.

Check the remaining users of ->f_path.dentry.  I agree that they ought to
be encapsulated into a sane set of helpers - raw access to ->f_path in
filesystems is asking for serious trouble.  And we have very few such places
remaining.

FWIW, I would prefer to have the whole stack of underlying dentries reachable
in a uniform way...

PS: I'll send review of your multilayer stuff today.
