Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaBUJpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:45:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbaBUJpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:45:51 -0500
Date: Fri, 21 Feb 2014 10:45:50 +0100
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Maxim Patlasov <MPatlasov@parallels.com>,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: avoid exposure of stale data in ext4_punch_hole()
 -v2
Message-ID: <20140221094550.GD12506@quack.suse.cz>
References: <20130926173113.23276.77451.stgit@dhcp-10-30-17-2.sw.ru>
 <20130927155329.3272.64086.stgit@dhcp-10-30-17-2.sw.ru>
 <20130927160517.GA5777@quack.suse.cz>
 <20140221002107.GB7232@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221002107.GB7232@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-02-14 19:21:07, Ted Tso wrote:
> On Fri, Sep 27, 2013 at 06:05:17PM +0200, Jan Kara wrote:
> > On Fri 27-09-13 19:54:03, Maxim Patlasov wrote:
> > > While handling punch-hole fallocate, it's useless to truncate page cache
> > > before removing the range from extent tree (or block map in indirect case)
> > > because page cache can be re-populated (by read-ahead or read(2) or mmap-ed
> > > read) immediately after truncating page cache, but before updating extent
> > > tree (or block map). In that case the user will see stale data even after
> > > fallocate is completed.
> > > 
> > > Changed in v2 (Thanks to Jan Kara):
> > >  - Until the problem of data corruption resulting from pages backed by
> > >    already freed blocks is fully resolved, the simple thing we can do now
> > >    is to add another truncation of pagecache after punch hole is done.
> >   The patch looks good. You can add:
> > Reviewed-by: Jan Kara <jack@suse.cz>
> 
> I was going through old patches, and it looks like this one got
> dropped.  My apologies.
> 
> As far as I can tell, the underlying problem in the VFS/MM layer
> hasn't been solved yet (Jan, can you confirm?), so I've queued this
> patch for the next merge window.
  Yes, we didn't solve it yet. Thanks for queueing the patch!

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
