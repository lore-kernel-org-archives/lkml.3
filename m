Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab3KVXwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:52:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53413 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3KVXwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:52:20 -0500
Date: Fri, 22 Nov 2013 23:52:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: recursive locking (coredump/vfs_write)
Message-ID: <20131122235217.GK10323@ZenIV.linux.org.uk>
References: <20131113211147.GA30263@redhat.com>
 <20131122211156.GA7520@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122211156.GA7520@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 10:11:56PM +0100, Jan Kara wrote:
>   Hi,
> 
> On Wed 13-11-13 16:11:47, Dave Jones wrote:
> > here's another one..
> > 
> > 
> > =============================================
> > [ INFO: possible recursive locking detected ]
> > 3.12.0+ #2 Not tainted
> > ---------------------------------------------
> > trinity-child3/13302 is trying to acquire lock:
> >  (sb_writers#5){.+.+.+}, at: [<ffffffff811b7013>] vfs_write+0x173/0x1f0
> > 
> > but task is already holding lock:
> >  (sb_writers#5){.+.+.+}, at: [<ffffffff8122006d>] do_coredump+0xf1d/0x1070
>   Thanks for report. Attached patch should fix this. Al, can you please
> merge it?

No.  It's already fixed in mainline by commit 52da40.
