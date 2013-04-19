Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3DSIog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 04:44:36 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:64911 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab3DSIod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 04:44:33 -0400
Date: Fri, 19 Apr 2013 10:44:28 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, Robin Holt <holt@sgi.com>,
        Ingo Molnar <mingo@redhat.com>, Russ Anderson <rja@sgi.com>,
        Shawn Guo <shawn.guo@linaro.org>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [Patch -v4 1/4] Migrate shutdown/reboot to boot cpu.
Message-ID: <20130419084428.GB27023@gmail.com>
References: <20130416095827.GJ3672@sgi.com>
 <20130416113256.GA10452@gmail.com>
 <20130416120624.GO3658@sgi.com>
 <20130416140101.GS3658@sgi.com>
 <20130417074653.GA31607@gmail.com>
 <20130417092737.GA12402@pd.tnic>
 <20130419075629.GE20897@gmail.com>
 <5171006D.40600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5171006D.40600@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> On 04/19/2013 01:26 PM, Ingo Molnar wrote:
> > 
> > * Borislav Petkov <bp@alien8.de> wrote:
> > 
> >> On Wed, Apr 17, 2013 at 09:46:53AM +0200, Ingo Molnar wrote:
> >>
> >>> What you mention here should indeed already be handled by the architecture 
> >>> hotplug code (for example on x86 the boot CPU cannot be hot-removed).
> >>
> >> Supposedly, some new Intels (I think Ivybridge or so) can actually be 
> >> hot-removed.
> > 
> > There are WIP patches in existence that remove the limitations on the kernel side, 
> > but they are not upstream yet, so currently the constraint exists upstream.
> > 
> 
> I thought Fenghua Yu's upstream commits were supposed to handle that. Don't they?

Hm, I thought there were more patches needed to support actual hardware - the 
feature also has various limitations related suspend/resume. Are these 
CPU0-hotplug commits all that was needed to support the new hot-pluggable 
hardware?

In any case, you are right - it's indeed possible upstream as well.

Thanks,

	Ingo
