Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab3DQJzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:55:09 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33375 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753260Ab3DQJzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:55:07 -0400
Date: Wed, 17 Apr 2013 04:55:01 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Robin Holt <holt@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michel Lespinasse <walken@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Tejun Heo <tj@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Patch -v4 4/4] Make reboot_cpuid a kernel parameter. other
 cpus.
Message-ID: <20130417095501.GD3658@sgi.com>
References: <20130416095641.GL3658@sgi.com>
 <20130416100439.GM3672@sgi.com>
 <fb8916e0-b41d-4f56-8cfd-3cf791fdc478@email.android.com>
 <20130416124411.GP3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416124411.GP3658@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 07:44:12AM -0500, Robin Holt wrote:
> On Tue, Apr 16, 2013 at 05:05:45AM -0700, H. Peter Anvin wrote:
> > Why not just support the existing syntax everywhere?
> 
> I have not given it much consideration, but IIRC, the other arches that
> were using reboot= were only looking for an 'h' or something like that.
> 
> I will consider making the syntax parse reboot=s#### when I get to
> the office.

Yesterday was rather disruptive and I did not get to this.  I have given
it some thought this morning.

Generally speaking, I don't like the feel of this for two reasons.  First,
having two different places that are parsing reboot=<reboot_mode> and
its related difficulty in documenting it.  Second, we lose the /sys/ file.

Some background.  First, arm.  It already has a reboot=<c>.  That <c>
gets passed to the reboot sub-arch function.  It looks like it is ignored,
but I am very uncertain of that as it is passed into an assembly routine.

Second unicore.  It parses as reboot=<c>.  That <c> gets ignored.

Now the meat of my question.  The Documentation/kernel-parameters.txt
file indicates reboot= is handled by the arch and are of the format
<reboot-mode>[,<reboot-mode>[,...]].

I suppose we could have both an arch and generic kernel handler for
__setup("reboot=",...)  where the generic kernel one just handles the
s###, but that seems really different from how everything else is done.
I could not find one instance where a both an arch and the kernel proper
both parsed the same command-line parameter.

I did not spend the time to see if having two __setup() declarations
would work.

Additionally, the __setup("... mechanism loses the nice feature the
core_param gives us in that there is a /sys/ file now available which
allows us to easily change that setting on the running system.

Are you really sure you want me to do more than I already have.  This
really feels _VERY_ wrong to me.  Maybe I misunderstood your direction.

Thanks,
Robin
