Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3FKEtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 00:49:17 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:63071 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3FKEtQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 00:49:16 -0400
Date: Mon, 10 Jun 2013 23:49:13 -0500
From: Rob Landley <rob@landley.net>
Subject: [RFC] is it time to split up the MAINTAINERS file?
To: linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.4.11
Message-Id: <1370926153.2776.95@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite possibly the answer is "no", but the MAINTAINERS file is  
approaching 10,000 lines. Getting a bit unwieldy.

Most of the entries look like:

ARM/SAMSUNG MOBILE MACHINE SUPPORT
M:      Kyungmin Park <kyungmin.park@samsung.com>
L:      linux-arm-kernel@lists.infradead.org (moderated for  
non-subscribers)
S:      Maintained
F:      arch/arm/mach-s5pv210/mach-aquila.c
F:      arch/arm/mach-s5pv210/mach-goni.c
F:      arch/arm/mach-exynos/mach-universal_c210.c
F:      arch/arm/mach-exynos/mach-nuri.c

Which could be moved to an arch/arm/MAINTAINERS file, and the relevant  
paths trimmed.

The question is: would this be an improvement? (And worth the changes  
to checkpatch.pl and such required to make it work?)

One potential _advantage_ of this is we could make the reporting  
hierarchy more explicit. The first entry in arch/arm/MAINTAINERS would  
be the arm maintainer and everybody else _under_ there goes through  
him. (Also, that guy could handle updates to the local MAINTAINERS file  
itself, so we're not always spamming Andrew. Such updates could even  
post to the architecture-specific list rather than linux-kernel.)

Yeah, reality isn't neatly nested. Lots of things refer to include  
files and Documentation files, but there's generally a main area of  
focus (where's the actual _code_?), and when you do have something like:

ARM/SHMOBILE ARM ARCHITECTURE
M:      Simon Horman <horms@verge.net.au>
M:      Magnus Damm <magnus.damm@gmail.com>
L:      linux-sh@vger.kernel.org
W:      http://oss.renesas.com
Q:      http://patchwork.kernel.org/project/linux-sh/list/
T:      git  
git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git next
S:      Supported
F:      arch/arm/mach-shmobile/
F:      drivers/sh/

You could either have the same entry in more than one MAINTAINERS file  
or keep it at a higher level. (This wouldn't eliminate the top level  
MAINTAINERS, merely trim it down a bit.)

Just throwing it out there. Seems like it might be a thing, someday  
anyway...

Rob