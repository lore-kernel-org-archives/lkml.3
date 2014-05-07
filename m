Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbaEGQnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbaEGQnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:43:39 -0400
Date: Wed, 7 May 2014 11:43:19 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140507164319.GB31555@treble.redhat.com>
References: <20140505132638.GA14432@treble.redhat.com>
 <20140505141038.GA27403@localhost.localdomain>
 <20140505184304.GA15137@gmail.com>
 <20140505214919.GE2099@localhost.localdomain>
 <20140506121211.GA4125@treble.redhat.com>
 <20140506140516.GF2099@localhost.localdomain>
 <20140506145010.GA6702@treble.redhat.com>
 <20140507122444.GB12234@gmail.com>
 <20140507154114.GA31555@treble.redhat.com>
 <20140507155754.GA15221@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140507155754.GA15221@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 05:57:54PM +0200, Ingo Molnar wrote:
> Live patching does not enter into this question, ever. The correctness 
> of a patch to the source does not depend on 'live patching' 
> considerations in any way, shape or form.
> 
> Any mechanism that tries to blur these lines is broken by design.
> 
> My claim is that if a patch is correct/safe in the old fashioned way, 
> then a fundamental principle is that a live patching subsystem must 
> either safely apply, or safely reject the live patching attempt, 
> independently from any user input.

That's a valiant goal, but it's not going to happen unless you want to
rewrite Linux in Haskell.  It's just not possible for a program to prove
that a patch is safe to apply to a running kernel.  There are way too
many subtle interactions with dynamically allocated data between
functions.

I think the only way to achieve that is with CRIU, but it still requires
a kexec or a reboot, so you lose all kernel state and it's much more
disruptive.

> "We think/hope it won't blow up in most cases and we automated some 
> checks halfways" or "the user must know what he is doing" is really 
> not something that I think is a good concept for something as fragile 
> as live patching.

This is a distro tool, not a general purpose one.  If distros are
careful with their patch selection, it won't blow up.  It's a valuable
way for distros to help out sysadmins who need a hot security fix but
can't reboot immediately.

-- 
Josh
