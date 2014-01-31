Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbaAaXLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 18:11:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaAaXLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 18:11:37 -0500
Date: Fri, 31 Jan 2014 18:11:29 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Drokin <green@linuxhacker.ru>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix mountpoint reference leakage in linkat
Message-ID: <20140131181129.2945f8aa@tlielax.poochiereds.net>
In-Reply-To: <20140131223013.GP10323@ZenIV.linux.org.uk>
References: <1391200918-29185-1-git-send-email-green@linuxhacker.ru>
	<20140131210334.GO10323@ZenIV.linux.org.uk>
	<A3886415-1FA1-4090-8F64-F5B4D4DDD786@linuxhacker.ru>
	<20140131163231.2585a08d@tlielax.poochiereds.net>
	<20140131223013.GP10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jan 2014 22:30:14 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, Jan 31, 2014 at 04:32:31PM -0500, Jeff Layton wrote:
> 
> >  	done_path_create(&new_path, new_dentry);
> > +	path_put(&old_path);
> 
> ... and the filesystem in question isn't pinned anymore, so it can be
> unmounted, except that
> 
> >  	if (delegated_inode) {
> >  		error = break_deleg_wait(&delegated_inode);
> 
> this does an iput() on delegated_inode.  And umount really doesn't
> like finding pinned inodes.  Sorry, no go.
> 
> I'm going with Oleg's patch with second path_put() added.

Good point. I hadn't considered that. Oleg's second patch looks good to
me too.

-- 
Jeff Layton <jlayton@redhat.com>
