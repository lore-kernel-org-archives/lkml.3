Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966443Ab3DQSXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 14:23:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:62272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3DQSXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 14:23:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,495,1363158000"; 
   d="scan'208";a="320712285"
Date: Wed, 17 Apr 2013 11:23:28 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC 5/7] Docs: Expectations for bug reporters and maintainers
Message-ID: <20130417182328.GA7690@xanatos>
References: <412f8f434c32c557b8c17e73163d003b895e2e56.1366046390.git.sarah.a.sharp@linux.intel.com>
 <1366164906.18069.110@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366164906.18069.110@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 09:15:06PM -0500, Rob Landley wrote:
> On 04/15/2013 12:33:34 PM, Sarah Sharp wrote:
> >Outline how often it's polite to ping kernel maintainers about
> >bugs, and
> >suggest that kernel maintainers should respond to bugs in 1 to 5
> >business days.
> 
> Is there anything in here about the four-level nature of modern
> maintainership?
> 
> Patches go from the developer, to the maintainer, to one of Linus's
> lieutenants, to Linus himself. If you submit a patch to a maintainer
> they owe you a response. The lieutenant (subsystem maintainer) owes
> that maintainer a response, and Linus (the project's architect) owes
> the lieutenant a response.

Do we want to go into this much detail in a document meant for
frustrated bug reporters?  Or perhaps we should create a separate
document about the kernel maintainer hierarchy and reference it here?

Also, please note that I'm writing this from the perspective of a driver
maintainer.  I'm not sure if we've met face to face. :)

> Linus does not owe you, personally, a response. Neither do the
> subsystem maintainers if you approach them directly with something
> that should have gone through one of the hundreds of domain-specific
> maintainers out of the Maintainers file. So the point of going to
> the right people in sequence and getting their review and
> signed-off-by lines is to ensure you don't sit there listening to
> crickets chirping while your patch is ignored. (If you approach
> Linus directly you may randomly _get_ a response, but there's no
> guarantee, and usually you won't because he's really busy.)

This file is about bug reporting, not submitting patches.  I rewrote
this file for the audience of people who would like to report a kernel
bug, but don't necessarily want to track it down and submit a patch
themselves.  Since this file isn't about submitting patches, let's focus
the discussion on bug reporters.

I agree that bug reporting should be done from the bottom up.  That's
why I tried to thoroughly explain how to find the right contact from
MAINTAINERS or get_maintainer.pl.

However, if a driver maintainer is not doing their job, is not
responding to regressions, it makes sense to escalate that up the chain.
Security holes in unmaintained code cause problems for anyone that uses
the Linux kernel, since distro kernels tend to turn nearly every config
option on.  If code is not being maintained, it may be better to remove
it, or at least mark it as depending on CONFIG_BROKEN.

If a driver maintainer isn't responding to a bug or security hole in a
timely manner, it makes sense to escalate that to the subsystem
maintainer who merges their patches.  Perhaps the driver maintainer is
on vacation, and the subsystem maintainer can tell the bug reporter
they'll have to wait.  Or maybe the driver maintainer has disappeared
completely from kernel development, and it's time someone else stepped
into their place.  Either way, the subsystem maintainer's job is to make
sure their subsystem is maintained by the driver maintainers under them.

If the subsystem maintainer doesn't respond, and it's a critical issue,
the last-ditch effort to get it fixed may need to be contacting Linus.
If there's serious code issues with a particular subsystem (like we've
seen in the past with the graphics subsystem or the ARM arch code), then
it makes sense for Linus to know about it.

TLDR version: Yes, it would be nice if bug reporters could go up the
hierarchy, but they don't have an easy way to know which subsystem
maintainers to contact.  Perhaps a new line in MAINTAINERS for the
subsystem maintainer would be helpful?

Sarah Sharp
