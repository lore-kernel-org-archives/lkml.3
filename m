Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaHFWYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:24:31 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47725 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaHFWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:24:29 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 6 Aug 2014 15:24:19 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
Message-ID: <20140806222419.GA2566@jtriplet-mobl1>
References: <20140806171344.GA15764@jtriplet-mobl1>
 <alpine.DEB.2.02.1408061504000.13545@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408061504000.13545@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 03:06:11PM -0700, David Rientjes wrote:
> On Wed, 6 Aug 2014, Josh Triplett wrote:
> > Since commit 5d2acfc7b974bbd3858b4dd3f2cdc6362dd8843a ("kconfig: make
> > allnoconfig disable options behind EMBEDDED and EXPERT") in 3.15-rc1,
> > "make allnoconfig" disables every possible config option.
> > 
> > However, a few configuration options (CC_OPTIMIZE_FOR_SIZE,
> > OPTIMIZE_INLINING) produce a smaller kernel when turned on, and a few
> > choices exist (compression, highmem, allocator) for which a non-default
> > option produces a smaller kernel.
> > 
> > Add a "tinyconfig" target, which starts from allnoconfig and then sets
> > these options to configure the tiniest possible kernel.  This provides a
> > better baseline for embedded systems or efforts to reduce kernel size.
> > 
> 
> I like it, the only comment that I have is that we already have a 
> xenconfig patchset sitting around that adds a helper function for this 
> functionality in the x86 Makefile that hasn't been merged yet.
> 
> The *config functionality is added in
> http://marc.info/?l=linux-kernel&m=140233900403377
> 
> and then used in
> http://marc.info/?l=linux-kernel&m=140233901403381
> http://marc.info/?l=linux-kernel&m=140233904503428
> 
> and have been pending since June.  I was going to ask Luis to rebase and 
> resend, but perhaps you can send the first patch along as a predecessor to 
> your patch and then let tinyconfig use build-virtconfig?

Sure, no problem.  I ended up modifying that patch a bit, but I included
a mini-changelog in it noting that I based it on Luis's patch.  Will
send a 2-patch v2 series momentarily, in response to this mail.

- Josh Triplett
