Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab3DPJkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:40:15 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43326 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3DPJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:40:12 -0400
Date: Tue, 16 Apr 2013 11:40:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robin Holt <holt@sgi.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Bulk CPU Hotplug (Was Re: [PATCH] Do not force shutdown/reboot
 to boot cpu.)
Message-ID: <20130416094008.GA10382@gmail.com>
References: <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com>
 <20130411053106.GA9042@drongo>
 <5166B05E.8010904@linux.vnet.ibm.com>
 <20130411134837.GE3672@sgi.com>
 <20130412053718.GC3887@gmail.com>
 <5167A52F.6020503@linux.vnet.ibm.com>
 <20130412093149.GT3658@sgi.com>
 <20130415101644.GC18024@gmail.com>
 <20130415120216.GX3658@sgi.com>
 <20130415155919.GZ3658@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130415155919.GZ3658@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robin Holt <holt@sgi.com> wrote:

> I have the patches sort-of finished.  The patch set starts by
> moving the halt/shutdown/reboot functions over to a new
> kernel/reboot.c, next patch gets a checkpatch.pl cleanup to
> work, third patch is essentially the below patch against the
> new file, and the fourth patch introduces a kernel boot parameter.
> 
> That said, I don't like them because of the 'stable' marking for
> these patches.  I think I am going submit them with the
> existing patch first in the series, then introduce the kernel parameter,
> then move them to kernel/reboot.c, and finally pass checkpatch.pl.
> 
> Does that sound alright?

Yeah, that ordering sounds right.

If there are no objections from others I'll first apply the first patch (with a 
-stable tag), test it for a day, then apply the rest.

Even patch #1 probably won't make it for v3.9-final [there's too many potential 
downsides IMHO], but this could be one of the cases where marking a patch for 
-stable and merging it in the merge window is legit.

Thanks,

	Ingo
