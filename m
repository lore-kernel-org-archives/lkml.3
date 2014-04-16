Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbaDPWqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 18:46:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaDPWqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 18:46:32 -0400
Date: Wed, 16 Apr 2014 15:46:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
Message-Id: <20140416154631.6d0173498c60619d454ae651@linux-foundation.org>
In-Reply-To: <534AD1EE.3050705@colorfullife.com>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	<20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
	<1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>
	<20140331170546.3b3e72f0.akpm@linux-foundation.org>
	<1396371699.25314.11.camel@buesod1.americas.hpqcorp.net>
	<CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>
	<1396377083.25314.17.camel@buesod1.americas.hpqcorp.net>
	<CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com>
	<1396386062.25314.24.camel@buesod1.americas.hpqcorp.net>
	<CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com>
	<20140401142947.927642a408d84df27d581e36@linux-foundation.org>
	<CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com>
	<20140401144801.603c288674ab8f417b42a043@linux-foundation.org>
	<1396389751.25314.26.camel@buesod1.americas.hpqcorp.net>
	<20140401150843.13da3743554ad541629c936d@linux-foundation.org>
	<534AD1EE.3050705@colorfullife.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2014 20:05:34 +0200 Manfred Spraul <manfred@colorfullife.com> wrote:

> Hi Andrew,
> 
> On 04/02/2014 12:08 AM, Andrew Morton wrote:
> > Well, I'm assuming 64GB==infinity. It *was* infinity in the RHEL5 
> > timeframe, but infinity has since become larger so pickanumber. 
> 
> I think infinity is the right solution:
> The only common case where infinity is wrong would be Android - and 
> Android disables sysv shm entirely.
> 
> There are two patches:
> http://marc.info/?l=linux-kernel&m=139730332306185&q=raw
> http://marc.info/?l=linux-kernel&m=139727299800644&q=raw
> 
> Could you apply one of them?
> I wrote the first one, thus I'm biased which one is better.

I like your patch because applying it might encourage you to send more
kernel patches - I miss the old days ;)

But I do worry about disrupting existing systems so I like Davidlohr's
idea of making the change a no-op for people who are currently
explicitly setting shmmax and shmall.

In an ideal world, system administrators would review this change,
would remove their explicit limit-setting and would retest everything
then roll it out.  But in the real world with Davidlohr's patch, they
just won't know that we did this and they'll still be manually
configuring shmmax/shmall ten years from now.  I almost wonder if we
should drop a printk_once("hey, you don't need to do that any more")
when shmmax/shmall are altered?


I think the changelogs for both patches could afford to spend much more
time talking about *why* we're making this change.  What problem is
the current code causing?  This is a somewhat risky change and we
should demonstrate good reasons for making it.  If people end up taking
damage because of this change, they are going to be looking at that
changelog trying to work out why we did this to them, so let's explain
it carefully.

