Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3LRUMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:12:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LRUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:12:48 -0500
Date: Wed, 18 Dec 2013 12:12:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Bruce Fields <bfields@fieldses.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [git pull] fixes for 3.12-final
Message-ID: <20131218201249.GC16267@kroah.com>
References: <20131103015803.GK13318@ZenIV.linux.org.uk>
 <CA+55aFy3tAeLYL3_+PbeD15p6PGS-P7bs8fMUaRVSC0OCzvq6w@mail.gmail.com>
 <20131103195452.GL13318@ZenIV.linux.org.uk>
 <CA+55aFwW9s3GCa+zNTMg7m44-cj2RdJp7wRpCnPUvQHm9xYnFg@mail.gmail.com>
 <20131104005300.GM13318@ZenIV.linux.org.uk>
 <20131106151003.GA21425@ZenIV.linux.org.uk>
 <20131113144353.GE28033@fieldses.org>
 <20131113151655.GG28033@fieldses.org>
 <20131118163243.GA30944@kroah.com>
 <20131218194034.GA22259@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218194034.GA22259@fieldses.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:40:34PM -0500, Bruce Fields wrote:
> On Mon, Nov 18, 2013 at 08:32:43AM -0800, Greg KH wrote:
> > On Wed, Nov 13, 2013 at 10:16:55AM -0500, Bruce Fields wrote:
> > > (Argh, sorry, with the right stable address cc'd this time I hope.)
> > > 
> > > On Wed, Nov 06, 2013 at 03:10:04PM +0000, Al Viro wrote:
> > > > FWIW, not taking ->i_lock there definitely looks like a good thing.  As for
> > > > 64bit ->i_ino itself...  Looks like the main problem is the shitload of
> > > > printks - the actual uses of ->i_ino are fine, but these suckers create
> > > > a lot of noise.  So for now I'm going with Bruce's variant; 64bit i_ino
> > > > doesn't look too bad (even on i386, actually), but it'll have to wait
> > > > until 3.14.  Too noisy and late in this cycle...
> > > 
> > > I believe we also want that in stable?
> > > 
> > > 950ee9566a5b6cc45d15f5fe044bab4f1e8b62cb "exportfs: fix 32-bit nfsd
> > > handling of 64-bit inode numbers"
> > 
> > It breaks the build in 3.12 and others so if it is needed, please
> > provide a backport that works properly to stable@vger.kernel.org.
> 
> Oops--there was a prerequisite patch that I forgot.  So we actually want
> 
> 	git cherry-pick b7a6ec52dd4eced4a9bcda9ca85b3c8af84d3c90
> 	git cherry-pick 950ee9566a5b6cc45d15f5fe044bab4f1e8b62cb

Thanks, I'll go take them now.

greg k-h
