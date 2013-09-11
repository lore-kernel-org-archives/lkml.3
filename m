Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3IKRwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:52:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18962 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab3IKRwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:52:39 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=cpn0iEa-oVMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uXgjhyO7DfoA:10 a=yPCof4ZbAAAA:8 a=tHz9FfFoAAAA:8 a=yjqx7b281KjzkrXuNWQA:9 a=CjuIK1q_8ugA:10 a=7DSvI1NPTFQA:10 a=6O0IECtVFhoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 13:52:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@akamai.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes
 for v3.12-rc1
Message-ID: <20130911135237.245386fb@gandalf.local.home>
In-Reply-To: <20130911172552.GB6870@phenom.dumpdata.com>
References: <201309110248.r8B2miI2032449@terminus.zytor.com>
	<20130911134717.GA10925@phenom.dumpdata.com>
	<20130911135745.GB11043@phenom.dumpdata.com>
	<20130911142545.GA11364@phenom.dumpdata.com>
	<20130911105633.1c029147@gandalf.local.home>
	<20130911152149.GA22076@phenom.dumpdata.com>
	<20130911114708.1b42aec0@gandalf.local.home>
	<20130911161745.GA5884@phenom.dumpdata.com>
	<20130911130507.44a2b115@gandalf.local.home>
	<20130911172552.GB6870@phenom.dumpdata.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 13:25:52 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:


> commit 97ce2c88f9ad42e3c60a9beb9fca87abf3639faa
> Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Date:   Wed Oct 12 16:17:54 2011 -0700
> 
>     jump-label: initialize jump-label subsystem much earlier
>     
>     Initialize jump_labels much, much earlier, so they're available for use
>     during system setup.
>     
>     Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> 
> implies that yes.

Unfortunately it does not. All that patch did was move
jump_label_init() up more. If anything, it implies "no".

The question is, can we enable jump_labels before jump_label_init()?

Note, we may still be able to (as it seems to work), the thing is, the
only thing that static_key_slow_inc() does is to tell jump_label_init()
to enable it. Before jump_label_init() is called, nothing has changed.
No code modification, all users of paravirt_ticketlocks_enabled are
still off.

-- Steve
