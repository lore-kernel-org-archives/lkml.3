Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742Ab3BSSmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:42:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21589 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3BSSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:42:16 -0500
Date: Tue, 19 Feb 2013 13:42:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Question about git branches, features, reverts, etc on subsystem
 maintainers tree?
Message-ID: <20130219184212.GA18831@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

I am hoping you can help out. I've a branch for 3.9 which has some
code that depends on the changes to the Xen hypervisor. The changes
to the Xen hypervisor are still in flux - aka they are not baked. The
code on the Linux side that uses this is marked with EXPERIMENTAL to
ward off novices.

To give you a 3.9 branch I am thinking to either:

 a). revert the merges I've for this new feature altogether and
     merge it later in v3.10 time-frame. They make about 50% off the
     code in this branch, so its big chunk of code movement.
     For 3.10 I could do a git revert of a revert and get everything
     in at once :-)

 b). create a new branch for you without the new features and
     just live with the shame of having the timestamp of patches
     being after the merge window.

 c). Rip out the Kconfig entry so there is not even an build option
     to build it. And then if the Xen hypervisor parts are bakend,
     add the Kconfig entry back and only deal with bug-fixes.
     A bit like adding #ifdef 0 .

The end result for a) and b) is the same - the amount of code that
would end up in the 'git diff --stat' is the same. It is just that
there are these abhorent git reverts in case a). The pedantic part
of me screams at the uncleanliness of a) option.

The b) is a bit like git rebase in spirit, except the only "rebase"
is that I've slimmed it down and not added new patches.

The c) is .. well, ignores the part of development where we might
need to re-engineer big parts of it (thought I doubt it, but you
never know). But those redevelopment parts can be part of v3.10.

Thoughts?
