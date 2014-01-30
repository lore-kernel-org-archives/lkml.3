Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaA3NHO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:07:14 -0500
Received: from verein.lst.de ([213.95.11.211]:53740 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbaA3NHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:07:13 -0500
Date: Thu, 30 Jan 2014 14:07:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20140130130709.GA21704@lst.de>
References: <20140127142520.GD10323@ZenIV.linux.org.uk> <CA+55aFyuC11WPBh0bWu_K3+CooAVAUbSTfk2aw5sks8eJRAhDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyuC11WPBh0bWu_K3+CooAVAUbSTfk2aw5sks8eJRAhDQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 07:26:08PM -0800, Linus Torvalds wrote:
> but the mode we're changing to (and what ATTR_MODE guards) is actually
> attr->ia_mode, not inode->i_mode. And quite frankly, passing in
> inode->i_mode looks stupid, since we're already passing in the inode
> pointer, so that's just redundant and pointless information.

At this point inode->i_mode has been updated to attra->ia_mode.  Passing
in the mode allows fileystems to defer the i_mode update until after
the ACL has been modified, which at this point only f2fs does.

In a perfect world filesystems do both under the same lock for in-core
access and in an transaction for the on-disk change, in which case
the exact order doesn't matter.

