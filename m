Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaGNPth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:49:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:19128 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633AbaGNPtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:49:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="543100258"
Date: Mon, 14 Jul 2014 08:49:30 -0700
From: Andi Kleen <ak@linux.intel.com>
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH] vfs: Turn the unlinked inode counter into a percpu
 counter
Message-ID: <20140714154930.GB5803@tassilo.jf.intel.com>
References: <1405110219-2969-1-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.00.1407141022580.13527@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1407141022580.13527@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/fs/inode.c b/fs/inode.c
> > index f96d2a6..4820c35 100644
> > --- a/fs/inode.c
> > +++ b/fs/inode.c
> > @@ -234,10 +234,8 @@ void __destroy_inode(struct inode *inode)
> >  	BUG_ON(inode_has_buffers(inode));
> >  	security_inode_free(inode);
> >  	fsnotify_inode_delete(inode);
> > -	if (!inode->i_nlink) {
> > -		WARN_ON(atomic_long_read(&inode->i_sb->s_remove_count) == 0);
> 
> This is not mentioned in the description, but I guess it makes sense since
> it'd be quite expensive.

Yes. I guess we could still check the local counter. I can re-add that.

-Andi
