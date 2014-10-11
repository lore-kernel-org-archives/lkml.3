Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaJKOOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 10:14:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60531 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752413AbaJKOOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 10:14:33 -0400
Date: Sat, 11 Oct 2014 15:14:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nathan Lynch <Nathan_Lynch@mentor.com>
Cc: Felipe Balbi <balbi@ti.com>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        josh@joshtriplett.org, Rabin Vincent <rabin@rab.in>,
        Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
Message-ID: <20141011141410.GM12379@n2100.arm.linux.org.uk>
References: <20141008175707.GI22688@saruman> <20141008212938.GP22688@saruman> <20141009160138.GA2396@cmpxchg.org> <20141009162656.GE16002@saruman> <20141009204101.GA25955@debian> <20141009204637.GE25729@saruman> <20141009210715.GH25729@saruman> <20141010135743.GB31348@saruman> <20141010162531.GL12379@n2100.arm.linux.org.uk> <54388B81.5020306@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54388B81.5020306@mentor.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 08:44:33PM -0500, Nathan Lynch wrote:
> On 10/10/2014 11:25 AM, Russell King - ARM Linux wrote:
> > We can blacklist these GCC versions quite easily.  We already have GCC
> > 3.3 blacklisted, and it's trivial to add others.  I would want to include
> > some proper details about the bug, just like the other existing entries
> > we already have in asm-offsets.c, where we name the functions that the
> > compiler is known to break where appropriate.
> 
> Before blacklisting anything, it's worth considering that simple version
> checks would break existing pre-4.8.3 compilers that have been patched
> for PR58854.  It looks like Yocto and Buildroot issued releases with
> patched 4.8.2 compilers well before the (fixed) 4.8.3 release.  I think
> the most we can reasonably do without breaking some correctly-behaving
> toolchains is to emit a warning.

I wish that it was possible to just do the warning thing, but unfortunately
evidence is that many people ignore compiler warnings, because they see
them appearing from the kernel soo often they have become de-sensitised
to them.

This is pretty obvious from the various nightly build systems which produce
the same warnings for months without any progress on them - some of them
can be quite serious (oops-able) where printf format strings are concerned.

> > for some time that GCC 4.8.1 and GCC 4.8.2 _can_ lead to filesystem
> > corruption, and have sat on their backsides doing nothing about getting
> > it blacklisted for something like a year.
> 
> Mea culpa, although I hadn't drawn the connection to FS corruption
> reports until now.  I have known about the issue for some time, but
> figured the prevalence of the fix in downstream projects largely
> mitigated the issue.

It's the FS corruption which swings it in favour of a #error - even if
we have a bunch of compilers around with that version which have the
problem fixed, it's /far/ better to #error out.  Those people who know
definitely that they have a fixed compiler can comment out the test
after checking that they do indeed have a fixed version, or are willing
to take the risk.

What we can't do is have kernels built by people who then run into FS
corruption because of this known issue.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
