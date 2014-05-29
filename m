Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbaE2LE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:04:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:21114 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbaE2LEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:04:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,933,1392192000"; 
   d="scan'208";a="438501120"
Date: Thu, 29 May 2014 14:04:39 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140529110439.GA2006@lahna.fi.intel.com>
References: <20140528031955.GW18016@ZenIV.linux.org.uk>
 <20140528073751.GB1757@lahna.fi.intel.com>
 <20140528115701.GY18016@ZenIV.linux.org.uk>
 <20140528131136.GA1643@lahna.fi.intel.com>
 <20140528141937.GZ18016@ZenIV.linux.org.uk>
 <20140528183954.GA18016@ZenIV.linux.org.uk>
 <20140529031149.GE18016@ZenIV.linux.org.uk>
 <20140529035233.GF18016@ZenIV.linux.org.uk>
 <20140529053444.GI18016@ZenIV.linux.org.uk>
 <20140529105107.GB1938@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529105107.GB1938@lahna.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:51:07PM +0300, Mika Westerberg wrote:
> On Thu, May 29, 2014 at 06:34:44AM +0100, Al Viro wrote:
> > On Thu, May 29, 2014 at 04:52:33AM +0100, Al Viro wrote:
> > > On Thu, May 29, 2014 at 04:11:49AM +0100, Al Viro wrote:
> > > > On Wed, May 28, 2014 at 07:39:54PM +0100, Al Viro wrote:
> > > > 
> > > > > OK, the warnings about averting your eyes very much apply; the thing below
> > > > > definitely needs more massage before it becomes acceptable (and no, it's
> > > > > not a single commit; I'm not that insane), but it changes behaviour in the
> > > > > way described above.  Could you check if the livelock persists with it?
> > > > > No trace-generating code in there, so the logs should be compact enough...
> > > > 
> > > > Here's an updated patch, hopefully slightly less vomit-inducing.  Should
> > > > give the same behaviour as the previous one...  Again, it's a cumulative
> > > > diff - I'm still massaging the splitup here.
> > > 
> > > BTW, it still leaves the "proceed to parent" case in shrink_dentry_list();
> > > in theory, it's also vulnerable to the same livelock.  Can be dealt pretty
> > > much the same way; I'd rather leave that one for right after -final, though,
> > > if the already posted variant turns out to be sufficient...
> > 
> > ... which is (presumably) dealt with the incremental I'd just sent to Linus;
> > seeing what kind of dumb mistakes I'm making, I'd better call it quits for
> > tonight - it's 1:30am here and I didn't have anywhere near enough sleep
> > yesterday.  I'd appeciate if you could test the patch immediately
> > upthread (from Message-ID: <20140529031149.GE18016@ZenIV.linux.org.uk>)
> > and see if it helps.  There's an incremental on top of it (from
> > Message-ID: <20140529052621.GH18016@ZenIV.linux.org.uk>) that might or
> > might not be a good idea.
> 
> Thanks for the patch.
> 
> I tested patch <20140529031149.GE18016@ZenIV.linux.org.uk> and it seems
> to improve things. After first plug/unplug I can see similar behaviour
> but after a while it recovered. I did several iterations of plug/unplug
> afterwards and didn't see the livelock to trigger.
> 
> dmesg is attached.
> 
> I'm going to try your incremental patch now.

With your both patches applied the problem is gone :-)

I did 20 plug/unplugs, rebooted the machine and another 20 plug/unplugs
and didn't see the livelock at once.

Thanks a lot!
