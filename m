Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637AbaG2MF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:05:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbaG2MF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:05:57 -0400
Date: Tue, 29 Jul 2014 14:05:55 +0200
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, jack@suse.cz
Subject: Re: Is warn_on() right reply for i/o error?
Message-ID: <20140729120555.GB5944@quack.suse.cz>
References: <20140724152721.GA4771@amd.pavel.ucw.cz>
 <20140724192938.GM6673@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724192938.GM6673@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-07-14 15:29:38, Ted Tso wrote:
> On Thu, Jul 24, 2014 at 05:27:22PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > Just... I know, I should not be unscrewing hard drive cover while
> > operating.
> > 
> > But on the other hand... WARN_ON() does not sound like right reply for
> > a disk failure... right?
> 
> Actually, it can be worse than that.  If a hard drive disappears out
> from under you while writeback is happening, it's possible to get
> crashes in bdi_writeack_workfn() because you can have races between
> bdi_unregister() and bdi_writeback_workfn(), since the latter requeues
> itself and flush_delayed_work() can return while
> bdi_writeback_workfn() is still executing.
  This should be fixed by 5acda9d12dcf1ad0d9a5a2a7c646de3472fa7555 I wrote
in April. But there are certainly other races in that code...

> This looks like it's a related problem, where the block device gets
> unregistered (and this happens in the block device layer without it
> telling the file system that the disk drive is about to disappear out
> from under it), and occasionally, Bad Stuff Happens.  :-(
  Yeah.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
