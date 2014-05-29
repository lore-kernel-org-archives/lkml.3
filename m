Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934654AbaE2Feu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:34:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54846 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933267AbaE2Fer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 01:34:47 -0400
Date: Thu, 29 May 2014 06:34:44 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140529053444.GI18016@ZenIV.linux.org.uk>
References: <20140527040026.GT18016@ZenIV.linux.org.uk>
 <20140527070409.GA1801@lahna.fi.intel.com>
 <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <20140529031149.GE18016@ZenIV.linux.org.uk>
 <20140529035233.GF18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529035233.GF18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 04:52:33AM +0100, Al Viro wrote:
> On Thu, May 29, 2014 at 04:11:49AM +0100, Al Viro wrote:
> > On Wed, May 28, 2014 at 07:39:54PM +0100, Al Viro wrote:
> > 
> > > OK, the warnings about averting your eyes very much apply; the thing below
> > > definitely needs more massage before it becomes acceptable (and no, it's
> > > not a single commit; I'm not that insane), but it changes behaviour in the
> > > way described above.  Could you check if the livelock persists with it?
> > > No trace-generating code in there, so the logs should be compact enough...
> > 
> > Here's an updated patch, hopefully slightly less vomit-inducing.  Should
> > give the same behaviour as the previous one...  Again, it's a cumulative
> > diff - I'm still massaging the splitup here.
> 
> BTW, it still leaves the "proceed to parent" case in shrink_dentry_list();
> in theory, it's also vulnerable to the same livelock.  Can be dealt pretty
> much the same way; I'd rather leave that one for right after -final, though,
> if the already posted variant turns out to be sufficient...

... which is (presumably) dealt with the incremental I'd just sent to Linus;
seeing what kind of dumb mistakes I'm making, I'd better call it quits for
tonight - it's 1:30am here and I didn't have anywhere near enough sleep
yesterday.  I'd appeciate if you could test the patch immediately
upthread (from Message-ID: <20140529031149.GE18016@ZenIV.linux.org.uk>)
and see if it helps.  There's an incremental on top of it (from
Message-ID: <20140529052621.GH18016@ZenIV.linux.org.uk>) that might or
might not be a good idea.

I'm crawling to bed right now; back in ~7 hours...
