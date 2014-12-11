Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbaLKSe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:34:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44688 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaLKSe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:34:58 -0500
Date: Thu, 11 Dec 2014 18:34:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [GIT PULL] vfs.git
Message-ID: <20141211183456.GY22149@ZenIV.linux.org.uk>
References: <20141210191302.GO22149@ZenIV.linux.org.uk>
 <CAELBmZDLTOskhHaZEMOPA8n9VgAcr0cJvqYjx=YADpx_=mYQcw@mail.gmail.com>
 <20141211180624.GX22149@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141211180624.GX22149@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 06:06:24PM +0000, Al Viro wrote:

> Check the remaining users of ->f_path.dentry.  I agree that they ought to
> be encapsulated into a sane set of helpers - raw access to ->f_path in
> filesystems is asking for serious trouble.  And we have very few such places
> remaining.

Sloppy writing: insert "with the exception of filesystems that are not
going to be suitable for any form of stacking" - there _is_ a bunch of
debugfs, configfs, kernfs places using that.  They'd also better be
taken care of, but it's an independent story; for overlayfs/unionmount/etc.
purposes they are non-issue.

BTW, there are several places where ->f_path.mnt access is the right thing
to do - in autofs.  Also a non-issue here...
