Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab3GAUEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:04:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:54329 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab3GAUEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:04:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="325365163"
Subject: [PATCH 0/7] Put "Kernel hacking" Kconfig menu on a diet
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 01 Jul 2013 13:04:40 -0700
Message-Id: <20130701200440.712D8B4E@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, I've tried to send these along to a couple of different
maintainers for a couple of merge windows, but so far nobody has
bitten.

--

I think the "Kernel Hacking" menu has gotten a bit out of hand.  It
is over 120 lines long on my system with everything enabled and
options are scattered around it haphazardly.

        http://sr71.net/~dave/linux/kconfig-horror.png

Let's try to introduce some sanity.  This set takes that 120 lines
down to 55 and makes it vastly easier to find some things.  It's a
start.

This set stands on its own, but there is plenty of room for follow-up
patches.  The arch-specific debug options still end up getting stuck
in the top-level "kernel hacking" menu.  OPTIMIZE_INLINING, for
instance, could obviously go in to the "compiler options" menu, but
the fact that it is defined in arch/ in a separate Kconfig file keeps
it on its own for the moment.

--

There is a fair amount of churn in the areas around these patches
so I've resolved conflicts a couple of times.  For the patches that
are almost purely code move patches, I'm doing this:

	cat foo.patch | grep '^[-+]' | perl -pe 's/^.//' | sort | uniq -c | sort -n

and watching for any non-even numbers coming out of uniq.  This
helps me make sure I'm not adding/removing code that I should not
be.

The Signed-off-by's in here look funky.  I changed employers
while working on this set, so I have signoffs from both email
addresses.  Here's the original posting:

	http://lkml.kernel.org/r/20121217182206.91AA150A@kernel.stglabs.ibm.com

