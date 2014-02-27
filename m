Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaB0XJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:09:11 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40735 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaB0XJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:09:10 -0500
Date: Thu, 27 Feb 2014 15:09:05 -0800
From: josh@joshtriplett.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 18/46] kernel: Mark functions as static in sched/fair.c
Message-ID: <20140227230905.GD30335@cloud>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
 <8addb2b0ca590ad5b3492ce1c6cb86b67905acd5.1393493277.git.rashika.kheria@gmail.com>
 <20140227115805.GE9987@twins.programming.kicks-ass.net>
 <20140227160322.GC26756@thin>
 <20140227192435.GA27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227192435.GA27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:24:35PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 27, 2014 at 08:03:22AM -0800, Josh Triplett wrote:
> > Did you perhaps check, and notice that there are *zero* uses of this
> > function in the kernel?  Nothing overrides this weak symbol; it is no
> > longer needed.  You removed the one and only user in your commit:
> 
> I know that; but you don't get to remove interfaces under the guise of a
> static checker and without mention of such in the changelog.

So the changelog message needed improvement.  Got it; that would have
been helpful to hear.

The kernel hardly goes to great lengths to preserve old interfaces with
no users (per stable_api_nonsense), and the commit message already stated
that the function was being marked as static because it wasn't used
elsewhere.  But sure, perhaps something like the following, added to the
commit message, would address your concern?

"""
arch_scale_smt_power, in particular, is a __weak function provided for
architectures to override.  However, the only overriding definition was
removed before v3.6, in commit ee08d1284ea9235b29bd2d9b7493b4b4cf3da09c
("sched/x86: Remove broken power estimation").  Thus, drop the __weak
and make the function static.
"""

Or would you prefer to see it completely eliminated (inlining it into
its caller) as part of the same patch?

- Josh Triplett
