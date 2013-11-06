Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3KFTAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:00:19 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46707 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3KFTAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:00:17 -0500
Date: Wed, 6 Nov 2013 13:59:36 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: Re: [PATCH v2 2/2] x86: add prefetching to do_csum
Message-ID: <20131106185936.GA11415@hmsreliant.think-freely.org>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-1-git-send-email-nhorman@tuxdriver.com>
 <1383751399-10298-3-git-send-email-nhorman@tuxdriver.com>
 <20131106153429.GA26336@redhat.com>
 <20131106155445.GB6357@neilslaptop.think-freely.org>
 <1383762190.4291.183.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383762190.4291.183.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 10:23:10AM -0800, Eric Dumazet wrote:
> On Wed, 2013-11-06 at 10:54 -0500, Neil Horman wrote:
> 
> > My guess was that the whole comment was made in reference to the fact that
> > checksum offload negated all these advantages.  Thats not so true anymore, since
> > infiniband needs csum in software for ipoib.
> > 
> > I'll fix this up and send a v3, but I'll give it a day in case there are more
> > comments first.
> 
> Also please include netdev, I think people there are interested.
> 
Sure, will do in the updated version

> I caught this message, but I usually cannot read lkml traffic.
> 
> I wonder why you do not use (and/or change/tune) prefetch_range()
> instead of a local definition.
> 
I wanted to look into this further, because I wasn't (yet) sure if it was  a bug
or not, but from what I can see x86_64 doesn't define ARCH_HAS_PREFECTH.  That
makes prefetch_range() a nop (I confirmed this via objdump).  It seems like we
should either define ARCH_HAS_PREFETCH on x86_64, or we should remove the
#ifdef from prefetch_range
> 
> 
> 
