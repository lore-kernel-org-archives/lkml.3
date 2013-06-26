Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3FZPCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:02:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48119 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751569Ab3FZPCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:02:18 -0400
Date: Wed, 26 Jun 2013 10:02:16 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Nathan Zimmer <nzimmer@sgi.com>,
        holt@sgi.com, rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, gregkh@linuxfoundation.org, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] Transparent on-demand memory setup initialization
	embedded in the (GFP) buddy allocator
Message-ID: <20130626150216.GB2210@asylum.americas.sgi.com>
References: <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com> <20130624203657.GA107621@asylum.americas.sgi.com> <20130625073819.GC11420@gmail.com> <51C9D1D6.20405@sgi.com> <51C9E4B7.2000007@zytor.com> <51C9E6CD.5080508@sgi.com> <20130626092248.GB27025@gmail.com> <20130626062850.a7ce5806.akpm@linux-foundation.org> <20130626133715.GA6424@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626133715.GA6424@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 03:37:15PM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 26 Jun 2013 11:22:48 +0200 Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > except that on 32 TB 
> > > systems we don't spend ~2 hours initializing 8,589,934,592 page heads.
> > 
> > That's about a million a second which is crazy slow - even my 
> > prehistoric desktop is 100x faster than that.
> > 
> > Where's all this time actually being spent?
> 
> See the earlier part of the thread - apparently it's spent initializing 
> the page heads - remote NUMA node misses from a single boot CPU, going 
> across a zillion cross-connects? I guess there's some other low hanging 
> fruits as well - so making this easier to profile would be nice. The 
> profile posted was not really usable.
> 
That is correct, from what I am seeing, using crude cycle counters, there is
far more time spent on the later nodes, i.e. memory near the boot node is 
initialized a lot faster then remote memory.

I think the other low hanging fruits are currently being drowned out by the
lack of locality.

Nate

> Btw., NUMA locality would be another advantage of on-demand 
> initialization: actual users of RAM tend to allocate node-local 
> (especially on large clusters), so any overhead will be naturally lower.
> 
> Thanks,
> 
> 	Ingo
