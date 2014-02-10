Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaBJVPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:15:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36333 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaBJVPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:15:01 -0500
Date: Mon, 10 Feb 2014 22:14:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140210211458.GA5002@laptop.programming.kicks-ass.net>
References: <20140206134825.305510953@infradead.org>
 <52F93B7C.2090304@tilera.com>
 <20140210205719.GY5002@laptop.programming.kicks-ass.net>
 <52F93FBB.1090108@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F93FBB.1090108@tilera.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:08:11PM -0500, Chris Metcalf wrote:
> (+LKML again)
> 
> On 2/10/2014 3:57 PM, Peter Zijlstra wrote:
> > On Mon, Feb 10, 2014 at 03:50:04PM -0500, Chris Metcalf wrote:
> >> On 2/6/2014 8:52 AM, Peter Zijlstra wrote:
> >>> Its been compiled on everything I have a compiler for, however frv and
> >>> tile are missing because they're special and I was tired.
> >> So what's the specialness on tile?
> > Its not doing the atomic work in ASM but uses magic builtins or such.
> >
> > I got the list of magic funcs for tilegx, but didn't look into the 32bit
> > chips.
> 
> Oh, I see.  The <asm/atomic.h> files on tile are already reasonably well-factored.
> 
> It's possible you could do better, but I think not by too much, other than possibly
> by using <asm-generic/atomic.h> for some of the common idioms like "subtraction
> is addition with a negative second argument", etc., which hasn't been done elsewhere.

The last patch 5/5 adds a few atomic ops; I could of course use
cmpxchg() loops for everything, but I found tilegx actually has fetch_or
and fetch_and to implement atomic_or() / atomic_and().

It doesn't have fetch_xor() from what I've been told so atomic_xor()
will have to become a cmpxchg() loop.
