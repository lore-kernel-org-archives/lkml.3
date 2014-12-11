Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934342AbaLKQS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:18:26 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58186 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbaLKQSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:18:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141210191302.GO22149@ZenIV.linux.org.uk>
References: <20141210191302.GO22149@ZenIV.linux.org.uk>
Date: Thu, 11 Dec 2014 17:18:21 +0100
Message-ID: <CAELBmZDLTOskhHaZEMOPA8n9VgAcr0cJvqYjx=YADpx_=mYQcw@mail.gmail.com>
Subject: Re: [GIT PULL] vfs.git
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 8:13 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:

>         * killing a bunch of ->f_path.dentry users (and f_dentry macro).
> Getting that completed will make life much simpler for unionmount/overlayfs,
> since then we'll be able to limit the places sensitive to file _dentry_
> to reasonably few.  Which allows to have file_inode(file) pointing to
> inode in a covered layer, with dentry pointing to (negative) dentry in
> union one.  Still not complete, but much closer now.

If we want f_path to point to union path, then shouldn't we be hiding
it from all but core VFS?  Filesystems have no business looking at the
mount anyway.  And looking at the union dentry will be just an endless
source of bugs.

Also some API changes are in order, like passing dentry to ->iterate()
for "readdirplus" like operations, since f_path.dentry won't be usable
for that purpose.  Alternatively replace f_inode with f_dentry and
make file_inode() use that.

Thanks,
Miklos
