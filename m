Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab3DLGNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 02:13:13 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:39961 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3DLGNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 02:13:11 -0400
Message-ID: <5167A52F.6020503@linux.vnet.ibm.com>
Date: Fri, 12 Apr 2013 11:39:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Robin Holt <holt@sgi.com>, Paul Mackerras <paulus@samba.org>,
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
References: <20130403193743.GB29151@sgi.com> <20130408155701.GB19974@gmail.com> <5162EC1A.4050204@zytor.com> <20130408165916.GA3672@sgi.com> <20130410111620.GB29752@gmail.com> <CA+55aFw8bRwMRm8cWtTGRvd1AEP-LR7pYL-pEoBkHqJUuJrjSg@mail.gmail.com> <20130411053106.GA9042@drongo> <5166B05E.8010904@linux.vnet.ibm.com> <20130411134837.GE3672@sgi.com> <20130412053718.GC3887@gmail.com>
In-Reply-To: <20130412053718.GC3887@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 13041206-1618-0000-0000-000003ABACF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 11:07 AM, Ingo Molnar wrote:
> 
> * Robin Holt <holt@sgi.com> wrote:
> 
>> For the v3.9 release, can we consider my awful patch?
> 
> How about trying what I suggested, to make reboot affine to the boot CPU 
> explicitly, not by shutting down all the other CPUs, but by set_cpus_allowed() or 
> so?
> 

I agree, that sounds like the right thing to do for 3.9. Of course, it would be
nice if Shawn could verify that doing that doesn't break his platform due to
some unknown corner case.

> That should solve the regression, without the ugly special-casing - while giving 
> time to address the hot-unplug performance bottleneck.
> 
> Once that is done disable_nonboot_cpus() can be used again for reboot.
> 
> (But no strong feelings either way - both solutions are a workaround in a sense.)
> 
 
Regards,
Srivatsa S. Bhat

