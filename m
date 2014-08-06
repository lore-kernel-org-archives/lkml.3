Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300AbaHFWGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:06:17 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63488 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbaHFWGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:06:14 -0400
Date: Wed, 6 Aug 2014 15:06:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
In-Reply-To: <20140806171344.GA15764@jtriplet-mobl1>
Message-ID: <alpine.DEB.2.02.1408061504000.13545@chino.kir.corp.google.com>
References: <20140806171344.GA15764@jtriplet-mobl1>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Josh Triplett wrote:

> Since commit 5d2acfc7b974bbd3858b4dd3f2cdc6362dd8843a ("kconfig: make
> allnoconfig disable options behind EMBEDDED and EXPERT") in 3.15-rc1,
> "make allnoconfig" disables every possible config option.
> 
> However, a few configuration options (CC_OPTIMIZE_FOR_SIZE,
> OPTIMIZE_INLINING) produce a smaller kernel when turned on, and a few
> choices exist (compression, highmem, allocator) for which a non-default
> option produces a smaller kernel.
> 
> Add a "tinyconfig" target, which starts from allnoconfig and then sets
> these options to configure the tiniest possible kernel.  This provides a
> better baseline for embedded systems or efforts to reduce kernel size.
> 

I like it, the only comment that I have is that we already have a 
xenconfig patchset sitting around that adds a helper function for this 
functionality in the x86 Makefile that hasn't been merged yet.

The *config functionality is added in
http://marc.info/?l=linux-kernel&m=140233900403377

and then used in
http://marc.info/?l=linux-kernel&m=140233901403381
http://marc.info/?l=linux-kernel&m=140233904503428

and have been pending since June.  I was going to ask Luis to rebase and 
resend, but perhaps you can send the first patch along as a predecessor to 
your patch and then let tinyconfig use build-virtconfig?
