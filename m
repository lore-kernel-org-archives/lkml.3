Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbaIWVxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:53:08 -0400
Received: from mail1.windriver.com ([147.11.146.13]:65215 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaIWVxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:53:06 -0400
Date: Tue, 23 Sep 2014 17:53:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-rt-users@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RT] Stable updates for v3.2-rt, v3.4-rt, v3.10-rt and v3.12-rt
 available
Message-ID: <20140923215330.GA24393@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that Steve has had some unanticipated issues thrown his way
recently, I thought it might be nice if one of the rest of us RT folk
helped out with the the patch monkey work required to get us the latest
GregKH stable content into the linux-stable-rt repo.

To that end, one can find the following 3.12/3.10/3.4/3.2 updates here:

   https://git.kernel.org/cgit/linux/kernel/git/paulg/linux-stable-rt.git/
   git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux-stable-rt.git


v3.12
-----
  -new tags:
	v3.12.28-rt42, v3.12.28-rt42-rebase
	v3.12.27-rt41, v3.12.27-rt41-rebase

  -updated branches:
	v3.12-rt: from v3.12.26-rt40 to v3.12.28-rt42 (via ff through 41)
	v3.12-rt-REBASE: from v3.12.26-rt40-rebase to v3.12.28-rt42-rebase


v3.10
-----
  -new tags:
	v3.10.55-rt58, v3.10.55-rt58-rebase
	v3.10.54-rt57, v3.10.54-rt57-rebase
	               v3.10.53-rt56-rebase
	               v3.10.52-rt55-rebase
	               v3.10.51-rt54-rebase
	               v3.10.50-rt53-rebase
	               v3.10.49-rt52-rebase
	               v3.10.48-rt51-rebase

  -updated branches:
	v3.10-rt: from v3.10.53-rt56 to v3.10.55-rt58 (via ff through 57)
	v3.10-rt-REBASE: tag v3.10.47-rt50-rebase to v3.10.55-rt58-rebase


v3.4
----
  -new tags:
	v3.4.98-rt122,  v3.4.98-rt122-rebase
	v3.4.99-rt123,  v3.4.99-rt123-rebase
	v3.4.100-rt124, v3.4.100-rt124-rebase
	v3.4.101-rt125, v3.4.101-rt125-rebase
	v3.4.102-rt126, v3.4.102-rt126-rebase
	v3.4.103-rt127, v3.4.103-rt127-rebase

  -updated branches:
	v3.4-rt: from v3.4.97-rt121 to v3.4.103-rt127 (via ff through 122-126) 
	v3.4-rt-REBASE: from v3.4.97-rt121-rebase to v3.4.103-rt127-rebase

v3.2
----
  -new tags:
	v3.2.61-rt90, v3.2.61-rt90-rebase
	v3.2.62-rt91, v3.2.62-rt91-rebase

  -updated branches:
	v3.2-rt: from v3.2.60-rt89 to v3.2.62-rt91 (via ff through 90) 
	v3.2-rt-REBASE: from v3.4.97-rt121-rebase to v3.4.103-rt127-rebase


Technical notes:
----------------

Recent -stable rtmutex fixes have made the merges of stable into the
respective v3.X-rt branches slightly non trivial (see the source around
"next_waiter" and similar.)  Fortunately Steve had done the merge for
v3.10-rt, and I used that as a reference on merging for v3.4-rt and
v3.2-rt to ensure I got it right (or at least consistent ;)

I've matched Steve's process, so the v3.X-rt branches remain fast fwd,
and tagged per each merged stable release, and the "-rebase" tags are
the patches layered on top of each stable endpoint, with all but the
most recent rebase tag being an "orphaned" tag (i.e. not on a branch).

As per all linux-stable-rt beforehand, the source files of the tags
v3.X.Y-rtZ are confirmed to be identical to those of v3.X.Y-rtZ-rebase
via confirming no output from "git diff v3.X.Y-rtZ v3.X.Y-rtZ-rebase".

All tags have been signed with the same key I used to sign the mainline
2.6.34.x longterm releases in the past, in case anyone wants to check.

Testing: The 3.2 and 3.12 were sanity boot tested on a core2-duo with
RT_FULL=y and a largely otherwise defconfig.  The 3.10 updates have been
fed into the kernel of the Yocto project, and I tested the 3.4 updates
for a tree I'm maintaining as part of another project.

Enjoy!
Paul.
--
