Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab3EGUsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:48:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:34227 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab3EGUsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="333389144"
Subject: [PATCH 0/7] Put "Kernel hacking" Kconfig menu on a diet
To: mmarek@suse.cz
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 07 May 2013 13:46:42 -0700
Message-Id: <20130507204642.D010DDC1@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, I figure you're the most logical person for these to go
through.

There is a fair amount of churn in the areas around these patches
so I've resolved conflicts a couple of times.  For the patches that
are almost purely code move patches, I'm doing this:

	cat foo.patch | grep '^[-+]' | perl -pe 's/^.//' | sort | uniq -c | sort -n

and watching for any non-even numbers coming out of uniq.  This
helps me make sure I'm not adding/removing code that I should not
be.

The Signed-off-by's in here look funky.  I changed employers
while working on this set, so I have signoffs from both email
addresses.

---

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

