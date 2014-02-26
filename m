Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaBZXRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:17:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaBZXRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:17:50 -0500
Date: Wed, 26 Feb 2014 15:17:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (akpm-current tree related)
Message-Id: <20140226151747.ed178fd9a9b098ba226db63c@linux-foundation.org>
In-Reply-To: <20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
	<20140226100234.GA23064@thin>
	<20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Feb 2014 10:00:26 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Josh,
> 
> On Wed, 26 Feb 2014 02:02:34 -0800 Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > On Wed, Feb 26, 2014 at 07:16:27PM +1100, Stephen Rothwell wrote:
> > > 
> > > After merging the final tree, today's linux-next build (powerpc64
> > > allnoconfig) failed like this:
> > > 
> > > arch/powerpc/kernel/built-in.o: In function `.machine_check_queue_event':
> > > (.text+0x11260): undefined reference to `.irq_work_queue'
> > > 
> > > Caused (or exposed) (along with a lot of warnings) by commit 3dd6115cd60b
> > > ("kconfig: make allnoconfig disable options behind EMBEDDED and EXPERT")
> > > from the apm-current tree.
> > 
> > Pre-existing, just now triggerable with just "make allnoconfig" rather
> > than manually turning off other options (like PRINTK) that select
> > IRQ_WORK.  (One of the goals of that commit: get those options more
> > widely used and build-tested.)
> > 
> > The following (untested) patch *should* fix this:
> > ----- 8< -----
> > From 36a5b6c87292b6c5eeb390ed6dc6acbb8f0a3767 Mon Sep 17 00:00:00 2001
> > From: Josh Triplett <josh@joshtriplett.org>
> > Date: Wed, 26 Feb 2014 01:58:02 -0800
> > Subject: [PATCH] ppc: Make PPC_BOOK3S_64 select IRQ_WORK
> 
> OK, I added this as a merge fix patch for Andrew's tree today.  Please
> check the build results overnight tonight (for next-20140227 at
> http://kisskb.ellerman.id.au/linux-next) and submit any more fixes for
> the allnoconfig build errors.

yes, let's keep
kconfig-make-allnoconfig-disable-options-behind-embedded-and-expert,
please.  We'll just need to slog our way through the breakage which it
exposes.


