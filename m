Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3FKHNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:13:47 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47536 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751388Ab3FKHNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:13:46 -0400
Message-ID: <1370934825.22004.21.camel@joe-AO722>
Subject: Re: [RFC] is it time to split up the MAINTAINERS file?
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 11 Jun 2013 00:13:45 -0700
In-Reply-To: <1370926153.2776.95@driftwood>
References: <1370926153.2776.95@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 23:49 -0500, Rob Landley wrote:
> Quite possibly the answer is "no", but the MAINTAINERS file is  
> approaching 10,000 lines. Getting a bit unwieldy.

I think it hasn't been much of a bottleneck problem.

> The question is: would this be an improvement? (And worth the changes  
> to checkpatch.pl and such required to make it work?)

shrug.

MAINTAINERS is still the most frequently updated file.
This division eliminates those changes.

> One potential _advantage_ of this is we could make the reporting  
> hierarchy more explicit. The first entry in arch/arm/MAINTAINERS would  
> be the arm maintainer and everybody else _under_ there goes through  
> him. (Also, that guy could handle updates to the local MAINTAINERS file  
> itself, so we're not always spamming Andrew. Such updates could even  
> post to the architecture-specific list rather than linux-kernel.)

MAINTAINERS updates aren't centralized.
There are lots of MAINTAINERS updates from sub-maintainers.

> Yeah, reality isn't neatly nested. Lots of things refer to include  
> files and Documentation files, but there's generally a main area of  
> focus (where's the actual _code_?), and when you do have something like:
> 
> ARM/SHMOBILE ARM ARCHITECTURE
> M:      Simon Horman <horms@verge.net.au>
> M:      Magnus Damm <magnus.damm@gmail.com>
> L:      linux-sh@vger.kernel.org
> W:      http://oss.renesas.com
> Q:      http://patchwork.kernel.org/project/linux-sh/list/
> T:      git  
> git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas.git next
> S:      Supported
> F:      arch/arm/mach-shmobile/
> F:      drivers/sh/
> 
> You could either have the same entry in more than one MAINTAINERS file  
> or keep it at a higher level. (This wouldn't eliminate the top level  
> MAINTAINERS, merely trim it down a bit.)
> 
> Just throwing it out there. Seems like it might be a thing, someday  
> anyway...

Patches talk...

Sprinkling a few hundred MAINTAINER styles files
around the tree would be the biggest negative.

But paths and files could be relative and absolute

F:	./			(everything at this directory and lower)
F:	./foo.c			(single file)
F:	Documentation/foo.txt	(absolute single file)

or add an initial / for the absolutes

F:	*/			(everything at this directory and lower)
F:	foo.c			(single file)
F:	/Documentation/foo.txt	(absolute single file)

make could be taught to create an overall integrated
MAINTAINERS, which would not be part of the files
managed by git/cvs from these submaintainer files.

Still, I think the "best" approach would be to enhance
git to manage this additional information instead.

Something akin to:
https://lkml.org/lkml/2007/8/14/256

Maybe some standardization of "git notes" or
"git annotate" might work.

A script could be written to create something like the
existing MAINTAINERS file from that too.


