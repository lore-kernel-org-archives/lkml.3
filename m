Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab3FYHi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 03:38:27 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:51953 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3FYHiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 03:38:23 -0400
Date: Tue, 25 Jun 2013 09:38:19 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: holt@sgi.com, travis@sgi.com, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
Message-ID: <20130625073819.GC11420@gmail.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
 <1371831934-156971-3-git-send-email-nzimmer@sgi.com>
 <20130623092840.GB13445@gmail.com>
 <20130624203657.GA107621@asylum.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624203657.GA107621@asylum.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nathan Zimmer <nzimmer@sgi.com> wrote:

> On Sun, Jun 23, 2013 at 11:28:40AM +0200, Ingo Molnar wrote:
> > 
> > That's 4.5 GB/sec initialization speed - that feels a bit slow and the 
> > boot time effect should be felt on smaller 'a couple of gigabytes' 
> > desktop boxes as well. Do we know exactly where the 2 hours of boot 
> > time on a 32 TB system is spent?
> 
> There are other several spots that could be improved on a large system 
> but memory initialization is by far the biggest.

My feeling is that deferred/on-demand initialization triggered from the 
buddy allocator is the better long term solution.

That will also make it much easier to profile/test memory init 
performance: boot up a large system and run a simple testprogram that 
allocates a lot of RAM.

( It will also make people want to optimize the initialization sequence 
  better, as it will be part of any freshly booted system's memory 
  allocation overhead. )

Thanks,

	Ingo
