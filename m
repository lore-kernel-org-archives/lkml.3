Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab3KHH1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 02:27:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:56461 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab3KHH1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 02:27:45 -0500
Date: Thu, 7 Nov 2013 23:27:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the userns tree
Message-ID: <20131108072732.GA27537@infradead.org>
References: <20131108175848.6ca49f0ee8fe2a6c1125394a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108175848.6ca49f0ee8fe2a6c1125394a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 05:58:48PM +1100, Stephen Rothwell wrote:
> Hi Eric,
> 
> After merging the userns tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> fs/namei.c: In function 'covered':
> fs/namei.c:3528:2: error: too many arguments to function '__lookup_mnt'
>   is_covered = d_mountpoint(dentry) && __lookup_mnt(mnt, dentry, 1);
>   ^
> 
> Caused by my incomplete merge resolution between commits 474279dc0f77
> ("split __lookup_mnt() in two functions") from the vfs tree and
> a3b4491433f2 ("vfs: Don't allow overwriting mounts in the current mount
> namespace") from the userns tree.

Btw, I don't think the userns tree has any business touching lookup
and mount semantics in namei.c without an explicit VFS signoff.

Please drop the tree for now.

