Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaCEMpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:45:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbaCEMpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:45:39 -0500
Date: Wed, 5 Mar 2014 13:45:36 +0100
From: Jan Kara <jack@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: gpf in simple_setattr
Message-ID: <20140305124536.GA32371@quack.suse.cz>
References: <52B23CEA.7090405@oracle.com>
 <52CD762B.7020600@oracle.com>
 <53123D81.6080003@oracle.com>
 <20140303214040.GA15265@quack.suse.cz>
 <53166920.709@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53166920.709@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-03-14 19:00:32, Sasha Levin wrote:
> On 03/03/2014 04:40 PM, Jan Kara wrote:
> >On Sat 01-03-14 15:05:21, Sasha Levin wrote:
> >>>ping again?
> >>>
> >>>I've been working on it, but don't see an obvious issue.
> >>>
> >>>It does look like an access to invalid memory easily doable from
> >>>userspace, so it should probably get fixed soon...
> >   Hum, can you maybe dump the name in dentry passed to simple_setattr()? Or
> >maybe even the whole path using dentry_path() (but not sure if that will
> >be workable on half-torn-down fs)? Maybe it will give us a hint at which
> >filesystem to look...
> 
> It's just garbage, this is why I'm having a hard time making any progress with
> this bug.
  OK, but that is strange because we hold a reference to the dentry so
noone should free it. So dentry->d_name should be valid... Is the rest of
the dentry also garbage? E.g. does dentry->d_inode still point to the inode
we call __mark_inode_dirty() on? Is dentry->d_sb == dentry->d_inode->i_sb?
Also if the inode isn't completely garbage, we can maybe infer something
from inode->i_op - that should point to some statically allocated
operations struct so we should be able to guess fs type from that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
