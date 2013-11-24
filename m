Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3KXJbs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 04:31:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58624 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab3KXJbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 04:31:44 -0500
Date: Sun, 24 Nov 2013 10:31:43 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: recursive locking (coredump/vfs_write)
Message-ID: <20131124093143.GA25132@quack.suse.cz>
References: <20131113211147.GA30263@redhat.com>
 <20131122211156.GA7520@quack.suse.cz>
 <20131122235217.GK10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122235217.GK10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 22-11-13 23:52:18, Al Viro wrote:
> On Fri, Nov 22, 2013 at 10:11:56PM +0100, Jan Kara wrote:
> >   Hi,
> > 
> > On Wed 13-11-13 16:11:47, Dave Jones wrote:
> > > here's another one..
> > > 
> > > 
> > > =============================================
> > > [ INFO: possible recursive locking detected ]
> > > 3.12.0+ #2 Not tainted
> > > ---------------------------------------------
> > > trinity-child3/13302 is trying to acquire lock:
> > >  (sb_writers#5){.+.+.+}, at: [<ffffffff811b7013>] vfs_write+0x173/0x1f0
> > > 
> > > but task is already holding lock:
> > >  (sb_writers#5){.+.+.+}, at: [<ffffffff8122006d>] do_coredump+0xf1d/0x1070
> >   Thanks for report. Attached patch should fix this. Al, can you please
> > merge it?
> 
> No.  It's already fixed in mainline by commit 52da40.
  Ah, right. After pull I can see that change. Sorry for the noise.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
