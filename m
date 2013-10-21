Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3JURqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 13:46:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38867 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3JURqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 13:46:20 -0400
Date: Mon, 21 Oct 2013 13:46:08 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple alu's
Message-ID: <20131021174608.GA4154@hmsreliant.think-freely.org>
References: <1381785560.2045.11.camel@edumazet-glaptop.roam.corp.google.com>
 <1381789127.2045.22.camel@edumazet-glaptop.roam.corp.google.com>
 <20131017003421.GA31470@hmsreliant.think-freely.org>
 <1381974128.2045.144.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018165034.GC4019@hmsreliant.think-freely.org>
 <1382116835.3284.23.camel@edumazet-glaptop.roam.corp.google.com>
 <20131018201133.GD4019@hmsreliant.think-freely.org>
 <1382130952.3284.43.camel@edumazet-glaptop.roam.corp.google.com>
 <20131020212910.GA3387@neilslaptop.think-freely.org>
 <1382376698.3284.68.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382376698.3284.68.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 10:31:38AM -0700, Eric Dumazet wrote:
> On Sun, 2013-10-20 at 17:29 -0400, Neil Horman wrote:
> > On Fri, Oct 18, 2013 at 02:15:52PM -0700, Eric Dumazet wrote:
> > > On Fri, 2013-10-18 at 16:11 -0400, Neil Horman wrote:
> > > 
> > > > #define BUFSIZ_ORDER 4
> > > > #define BUFSIZ ((2 << BUFSIZ_ORDER) * (1024*1024*2))
> > > > static int __init csum_init_module(void)
> > > > {
> > > > 	int i;
> > > > 	__wsum sum = 0;
> > > > 	struct timespec start, end;
> > > > 	u64 time;
> > > > 	struct page *page;
> > > > 	u32 offset = 0;
> > > > 
> > > > 	page = alloc_pages((GFP_TRANSHUGE & ~__GFP_MOVABLE), BUFSIZ_ORDER);
> > > 
> > > Not sure what you are doing here, but its not correct.
> > > 
> > Why not?  You asked for a test with 32 hugepages, so I allocated 32 hugepages.
> 
> Not really. We cannot allocate 64 Mbytes in a single alloc_pages() call
> on x86. (MAX_ORDER = 11)
> 
> You noticed nothing because you did not 
> write anything on the 64Mbytes area (and corrupt memory) or
> use CONFIG_DEBUG_PAGEALLOC=y.
> 
> Your code read data out of bounds and was lucky, thats all...
> 
> You in fact allocated a page of (4096<<4) bytes
> 
Gahh!  I see what I did, the order in the alloc_pages call is the order of
hugepages, it still allocates that order as typically sized pages, and then
treats them as huge.  Stupid of me...

I'll have results on your version of the test case in just a bit here
Neil

> 
> 
> 
