Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaHDI6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:58:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37191 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaHDI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:58:10 -0400
Date: Mon, 4 Aug 2014 09:57:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH - V2] VFS: allow ->d_manage() to declare -EISDIR in
 rcu_walk mode.
Message-ID: <20140804085731.GP18016@ZenIV.linux.org.uk>
References: <20140730160833.5eac00ec@notabene.brown>
 <20140801083318.GA4907@mwanda>
 <20140801184815.22dd193f@notabene.brown>
 <20140804170629.5b2c9013@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140804170629.5b2c9013@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 05:06:29PM +1000, NeilBrown wrote:
> 
> In REF-walk mode, ->d_manage can return -EISDIR to indicate
> that the dentry is not really a mount trap (or even a mount point)
> and that any mounts or any DCACHE_NEED_AUTOMOUNT flag should be
> ignored.
> 
> RCU-walk mode doesn't currently support this, so if there is a dentry
> with DCACHE_NEED_AUTOMOUNT set but which shouldn't be a mount-trap,
> lookup_fast() will always drop in REF-walk mode.
> 
> With this patch, an -EISDIR from ->d_manage will always cause mounts
> and automounts to be ignored, both in REF-walk and RCU-walk.

In queue.  Right now I'm trying to linearize the damn acct fixes from late
April, needed to get Eric's umount-on-rmdir series into the mix safely ;-/
Hopefully I'll have something pushable by Tuesday; your patch definitely
will be in the pile.
