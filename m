Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3JCCuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 22:50:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41390 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab3JCCuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 22:50:10 -0400
Date: Thu, 3 Oct 2013 03:50:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Linus Torvalds <torvalds@osdl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org
Subject: Re: [rfc] rework aio migrate pages to use aio fs
Message-ID: <20131003025007.GC13318@ZenIV.linux.org.uk>
References: <20130913165937.GL2517@kvack.org>
 <20130913184204.GS13318@ZenIV.linux.org.uk>
 <20130917141825.GF11526@kvack.org>
 <20131003022251.GB13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003022251.GB13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 03:22:51AM +0100, Al Viro wrote:
> > +	/*
> > +	 * Link the inode to a directory entry by creating a unique name
> > +	 * using the inode sequence number.
> > +	 */
> > +	file = ERR_PTR(-ENOMEM);
> > +	this.name = name;
> > +	this.len = strlen(name);
> > +	this.hash = 0;
> 
> Umm...  ITYM
> 	struct qstr this = QSTR_INIT("[aio]", 5);
> , if not
> 	path.dentry = d_alloc_pseudo(aio_mnt->mnt_sb,
> 				     &(struct qstr)QSTR_INIT("[aio]", 5));
> > +	if (!path.dentry)
> > +		goto err_module;

and you've leaked that inode, BTW.

Another thing: I'd rather pull everything about setting the inode
up (aops, size, etc.) in there.

Anyway, could you take a look at the last couple of commits in
vfs.git#for-bcrl?  Commit message on the last one is an atrocity,
of course...
