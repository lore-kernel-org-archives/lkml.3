Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaIJN3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:29:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaIJN3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:29:08 -0400
Date: Wed, 10 Sep 2014 15:28:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
Message-ID: <20140910132857.GA4783@worktop.ger.corp.intel.com>
References: <alpine.DEB.2.11.1409081343270.29974@vincent-weaver-1.umelst.maine.edu>
 <20140908185115.GI6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1409091203500.14857@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091317550.15651@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>
 <20140910083136.GP6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:18:35AM -0400, Vince Weaver wrote:

> Somehow something is stomping over memory with a forking workload (likely 
> an improper free with RCU like we've seen before) but the fact that it 
> causes a reboot immediately makes it *really* hard to debug this.

Yes, the insta reboot thing is a total pain. Too bad Steve is out for a
spell; the only thing I can think of is trying to 'preserve' the trace
buffer over the reboot; its a warm reboot and memory contents should be
'stable'. So if we can get the new boot to agree with the old kernel's
idea of trace buffers we might retain enough.

Another approach would be using the firewire debug facility to read the
trace buffer post-mortem. Of course, that requires you have FW in at
least two boxes and an appropriate cable (not something I've actually
ever done due to lack of FW hardware).

Maybe the EHCI debug port (USB) might provide similar capabilities --
again, significant lack of experience due to not actually having
hardware for that.

I think I've once managed to hit the triple fault reboot in qemu/kvm,
which makes inspecting the dead state tons easier, if you can manage to
reproduce in a virt environment you've got a chance (of course, the
problem at that time was not perf and so a lot less sensitive to
hardware).

