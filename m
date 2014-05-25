Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaEYDSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 23:18:53 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38758 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaEYDSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 23:18:51 -0400
X-Originating-IP: 50.43.32.211
Date: Sat, 24 May 2014 20:18:38 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Fabian Frederick <fabf@skynet.be>, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] lib/debugobjects.c: move __initdata after name
Message-ID: <20140525031837.GA26400@thin>
References: <1400936839-25007-1-git-send-email-fabf@skynet.be>
 <20140524215634.GC24038@thin>
 <20140525051338.44cbb304b48f28625fa60c1b@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140525051338.44cbb304b48f28625fa60c1b@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Andy and Joe to CC.

On Sun, May 25, 2014 at 05:13:38AM +0200, Fabian Frederick wrote:
> On Sat, 24 May 2014 14:56:35 -0700
> Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > On Sat, May 24, 2014 at 03:07:19PM +0200, Fabian Frederick wrote:
> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > 
> > No, don't make this change.  A quick "git grep __initdata" shows that to
> > the extent it has a consistent placement, it's either right after the
> > type ("static some_type __initdata varname") or right after the storage
> > class ("static __initdata some_type varname").  Other similar qualifiers
> > follow the same pattern.
> 
> It was another checkpatch warning asking to put __initdata after variable name...

Gah.  That warning should not exist.  Looks like it got added in
8716de383b82f16d920513138f1691e40ef5a9e3 ("checkpatch: add test for
positional misuse of section specifiers like __initdata").  The error
for placement that GCC doesn't understand seems perfectly fine, but
checkpatch should *not* complain about "static __initdata struct foo
..."; that's perfectly understandable, and the order the majority of the
kernel uses.  Please get rid of that warning, and just keep the error
for the case GCC doesn't understand.

- Josh Triplett
