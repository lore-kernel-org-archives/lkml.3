Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaBFSah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:30:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56299 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaBFSaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:30:35 -0500
Date: Thu, 6 Feb 2014 19:30:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        mingo@kernel.org, will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        ramana.radhakrishnan@arm.com
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140206183028.GK5002@laptop.programming.kicks-ass.net>
References: <20140206134825.305510953@infradead.org>
 <21984.1391711149@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21984.1391711149@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 06:25:49PM +0000, David Howells wrote:
> 
> Is it worth considering a move towards using C11 atomics and barriers and
> compiler intrinsics inside the kernel?  The compiler _ought_ to be able to do
> these.
> 
> One thing I'm not sure of, though, is how well gcc's atomics will cope with
> interrupt handlers touching atomics on CPUs without suitable atomic
> instructions - that said, userspace does have to deal with signals getting
> underfoot. but then userspace can't normally disable interrupts.

I can do an asm-generic/atomic_c11.h if people want.
