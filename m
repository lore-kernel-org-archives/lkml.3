Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaJKOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 10:16:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60551 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752390AbaJKOQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 10:16:56 -0400
Date: Sat, 11 Oct 2014 15:16:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Chen <peter.chen@freescale.com>
Cc: Nathan Lynch <Nathan_Lynch@mentor.com>, Felipe Balbi <balbi@ti.com>,
        Rik van Riel <riel@redhat.com>,
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
Message-ID: <20141011141638.GN12379@n2100.arm.linux.org.uk>
References: <20141008212938.GP22688@saruman> <20141009160138.GA2396@cmpxchg.org> <20141009162656.GE16002@saruman> <20141009204101.GA25955@debian> <20141009204637.GE25729@saruman> <20141009210715.GH25729@saruman> <20141010135743.GB31348@saruman> <20141010162531.GL12379@n2100.arm.linux.org.uk> <54388B81.5020306@mentor.com> <20141011035431.GK3756@peterchendt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141011035431.GK3756@peterchendt>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 11:54:32AM +0800, Peter Chen wrote:
> On Fri, Oct 10, 2014 at 08:44:33PM -0500, Nathan Lynch wrote:
> > On 10/10/2014 11:25 AM, Russell King - ARM Linux wrote:
> > > 
> > > Right, so GCC 4.8.{1,2} are totally unsuitable for kernel building (and
> > > it seems that this has been known about for some time.)
> > 
> > Looking at http://gcc.gnu.org/PR58854 it seems that all 4.8.x for x < 3
> > are affected, as well as 4.9.0.
> > 
> > > We can blacklist these GCC versions quite easily.  We already have GCC
> > > 3.3 blacklisted, and it's trivial to add others.  I would want to include
> > > some proper details about the bug, just like the other existing entries
> > > we already have in asm-offsets.c, where we name the functions that the
> > > compiler is known to break where appropriate.
> > 
> > Before blacklisting anything, it's worth considering that simple version
> > checks would break existing pre-4.8.3 compilers that have been patched
> > for PR58854.  It looks like Yocto and Buildroot issued releases with
> > patched 4.8.2 compilers well before the (fixed) 4.8.3 release.  I think
> > the most we can reasonably do without breaking some correctly-behaving
> > toolchains is to emit a warning.
> 
> Yocto has PR58854 problem patch.
> 
> http://git.yoctoproject.org/cgit/cgit.cgi/poky/tree/meta/recipes-devtools/gcc/gcc-4.8/0048-PR58854_fix_arm_apcs_epilogue.patch?h=daisy

Right, and we can provide links to these in the comments above the #error
so people have the right places to do a bit of research into whether their
compiler is safe.

It is unfortunate that they are indistinguishable from the broken versions,
but that's really a distro problem for causing that issue themselves -
especially given how serious this bug is.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
