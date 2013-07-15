Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3GORYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:24:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3GORYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:24:40 -0400
Date: Mon, 15 Jul 2013 13:24:23 -0400
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        rostedt@goodmis.org
Subject: Re: nohz: Warn if the machine can not perform nohz_full
Message-ID: <20130715172423.GA27745@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	rostedt@goodmis.org
References: <20130715170859.GA25570@redhat.com>
 <20130715171800.GD6442@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130715171800.GD6442@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 07:18:02PM +0200, Frederic Weisbecker wrote:
 
 > > So I guess you guys never want this to be enabled on distro kernels ?
 > > If that's the case, can you add something to that effect in Kconfig ?
 > 
 > I believe we want it to be enabled on distros in the long term. But right now it would
 > be a bad idea until the off case (nohz_full= parameter empty) is carefully optimized.
 > I'm currently working on that.
 > 
 > Now for the unstable tsc, which is what it's about on the above code block, we need
 > the tick to be there to leverage the sched clock madness. May be there could be some
 > other solution that could work along full dynticks but for now we chose the easy path.
 > 
 > Are broken TSCs that common?
 
I just hit one apparently.  http://paste.fedoraproject.org/25421/73907845/raw/
That's a fairly recent Atom board, so I suspect it's not uncommon on that platform.

 > Also what is the preffered way to tell the distros that they shouldn't enable that option
 > for now? Here is what we currently have in the tail of the related Kconfig help:
 > 
 >         This is implemented at the expense of some overhead in user <-> kernel
 >         transitions: syscalls, exceptions and interrupts. Even when it's
 >         dynamically off.

"This feature is not ready to be deployed" ?

"This will taint the kernel if it decides it can't work" ?

	Dave

