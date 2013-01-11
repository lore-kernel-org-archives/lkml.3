Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3AKUbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 15:31:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3AKUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 15:31:50 -0500
Date: Fri, 11 Jan 2013 12:31:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: paul.szabo@sydney.edu.au
Cc: 695182@bugs.debian.org, dave@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] Reproducible OOM with partial workaround
Message-Id: <20130111123149.c3232a96.akpm@linux-foundation.org>
In-Reply-To: <201301111151.r0BBpZt1023276@como.maths.usyd.edu.au>
References: <20130111000119.8e9bdf5d.akpm@linux-foundation.org>
	<201301111151.r0BBpZt1023276@como.maths.usyd.edu.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2013 22:51:35 +1100
paul.szabo@sydney.edu.au wrote:

> Dear Andrew,
> 
> > Check /proc/slabinfo, see if all your lowmem got eaten up by buffer_heads.
> 
> Please see below: I do not know what any of that means. This machine has
> been running just fine, with all my users logging in here via XDMCP from
> X-terminals, dozens logged in simultaneously. (But, I think I could make
> it go OOM with more processes or logins.)

I'm counting 107MB in slab there.  Was this dump taken when the system
was at or near oom?

Please send a copy of the oom-killer kernel message dump, if you still
have one.

> > If so, you *may* be able to work around this by setting
> > /proc/sys/vm/dirty_ratio really low, so the system keeps a minimum
> > amount of dirty pagecache around.  Then, with luck, if we haven't
> > broken the buffer_heads_over_limit logic it in the past decade (we
> > probably have), the VM should be able to reclaim those buffer_heads.
> 
> I tried setting dirty_ratio to "funny" values, that did not seem to
> help.

Did you try setting it as low as possible?

> Did you notice my patch about bdi_position_ratio(), how it was
> plain wrong half the time (for negative x)? 

Nope, please resend.

> Anyway that did not help.
> 
> > Alternatively, use a filesystem which doesn't attach buffer_heads to
> > dirty pages.  xfs or btrfs, perhaps.
> 
> Seems there is also a problem not related to filesystem... or rather,
> the essence does not seem to be filesystem or caches. The filesystem
> thing now seems OK with my patch doing drop_caches.

hm, if doing a regular drop_caches fixes things then that implies the
problem is not with dirty pagecache.  Odd.

