Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaEFMdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:33:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:32077 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752524AbaEFMdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:33:49 -0400
Date: Tue, 6 May 2014 08:33:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140506083346.2c96b8ad@gandalf.local.home>
In-Reply-To: <20140506121211.GA4125@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
	<20140505085537.GA32196@gmail.com>
	<20140505132638.GA14432@treble.redhat.com>
	<20140505141038.GA27403@localhost.localdomain>
	<20140505184304.GA15137@gmail.com>
	<20140505214919.GE2099@localhost.localdomain>
	<20140506121211.GA4125@treble.redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 07:12:11 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> Live patching is a very sensitive and risky operation, and from a kernel
> standpoint we should make it as safe as we reasonably can.  But we can't
> do much about careless users.  Ultimately the risk is in the hands of
> the user and their choice of patches.  They need to absolutely
> understand all the implications of patching a particular function.  If
> the patch changes the way a function interacts with some external data,
> then they're starting to tempt fate and they need to be extra careful.
> This care needs to be taken for *all* kernel functions, not just for the
> few that are called from kernel threads.

Ideally the kpatch tools should be able to somewhat prevent users from
doing damage. Or at least make them type a sentence that says:

  I know what I'm doing and will not blame anyone but myself if this
  kills the system along with all my puppies and kittens.

I'm guessing that kpatch needs to be marketed that a distro or "hired
help" will be creating the patch and the admin only needs to "trust"
the one that gave them the kpatch module to load. All the
testing/checking that the module works will be done by kernel
developers and not by any "users".


-- Steve
