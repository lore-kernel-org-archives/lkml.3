Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3KLV3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 16:29:06 -0500
Received: from relay3.sgi.com ([192.48.152.1]:52897 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755984Ab3KLV3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 16:29:03 -0500
Date: Tue, 12 Nov 2013 15:29:02 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: mm, numa: test segfaults, only when NUMA balancing is on
Message-ID: <20131112212902.GA4725@sgi.com>
References: <20131016155429.GP25735@sgi.com>
 <20131104145828.GA1218@suse.de>
 <20131104200346.GA3066@sgi.com>
 <20131106131048.GC4877@suse.de>
 <20131107214838.GY3066@sgi.com>
 <20131108112054.GB5040@suse.de>
 <20131108221329.GD4236@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108221329.GD4236@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 04:13:29PM -0600, Alex Thorlton wrote:
> On Fri, Nov 08, 2013 at 11:20:54AM +0000, Mel Gorman wrote:
> > On Thu, Nov 07, 2013 at 03:48:38PM -0600, Alex Thorlton wrote:
> > > > Try the following patch on top of 3.12. It's a patch that is expected to
> > > > be merged for 3.13. On its own it'll hurt automatic NUMA balancing in
> > > > -stable but corruption trumps performance and the full series is not
> > > > going to be considered acceptable for -stable
> > > 
> > > I gave this patch a shot, and it didn't seem to solve the problem.
> > > Actually I'm running into what appear to be *worse* problems on the 3.12
> > > kernel.  Here're a couple stack traces of what I get when I run the test
> > > on 3.12, 512 cores:
> > > 
> > 
> > Ok, so there are two issues at least. Whatever is causing your
> > corruption (which I still cannot reproduce) and the fact that 3.12 is
> > worse. The largest machine I've tested with is 40 cores. I'm trying to
> > get time on a 60 core machine to see if has a better chance. I will not
> > be able to get access to anything resembling 512 cores.
> 
> At this point, the smallest machine I've been able to recreate this
> issue on has been a 128 core, but it's rare on a machine that small.
> I'll kick off a really long run on a 64 core over the weekend and see if
> I can hit it on there at all, but I haven't been able to previously.

Just a quick update, I ran this test 500 times on 64 cores, allocating
512m per core, and every single test completed successfully.  At this
point, it looks like you definitely need at least 128 cores to reproduce
the issue.

- Alex
