Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaLaMks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:40:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:36344 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaLaMkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:40:46 -0500
Date: Tue, 30 Dec 2014 17:45:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the rcu tree
Message-ID: <20141231014521.GL11609@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141226185120.402d392f@canb.auug.org.au>
 <20141226165401.GH11609@linux.vnet.ibm.com>
 <CAJhHMCCErUVzD_9mYZOVo=Z_FuBQVV53XWMX_SMEfVUZmBEcRQ@mail.gmail.com>
 <CAJhHMCBzF3ZgEP7SyLKzBTHxUmkn27fq7JyxyKe1nktiELXZPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBzF3ZgEP7SyLKzBTHxUmkn27fq7JyxyKe1nktiELXZPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14123112-0017-0000-0000-0000078FABBC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 12:20:50PM -0500, Pranith Kumar wrote:
> On Sat, Dec 27, 2014 at 11:24 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> > On Fri, Dec 26, 2014 at 11:54 AM, Paul E. McKenney wrote:
> >> Pranith, if Stephen has CONFIG_KVM=n, it might be best to move the
> >> "select SRCU" to "config PPC" in arch/powerpc/Kconfig.  Are you able
> >> to cross-build powerpc?
> >>
> >
> > ppc 32 seems fine without selecting srcu unconditionally. So I added
> > this select to PPC 64 which should fix this build failure.
> 
> On looking at this further, I was able to figure out the parts on
> ppc64 utilizing KVM and enabled them dependent on CONFIG_KVM being
> enabled. I tested this with a ppc64 allnoconfig and it built
> succesfully (depending on a unrelated patch to enable printk for
> powernv).
> 
> I've sent the patch but it still seems that we will be playing
> whack-a-mole for now with code which uses KVM indepedent of
> CONFIG_KVM. May be fixing it incrementally is a better option than
> lumping all these together?

For PPC64, I suggest starting with something that can be trivially shown
to work, even if it consumes more memory than required.  The PPC64 systems
almost always have an abundance of memory, so having SRCU unnecessarily
built into the system is not all that bad -- and is what happens today
anyway.

Given that starting point, you can then build a more precise patch for
PPC64 on top of the starting-point patch.

Make sense?

							Thanx, Paul

