Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3IKN5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:57:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9939 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3IKN5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:57:37 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=cpn0iEa-oVMA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uXgjhyO7DfoA:10 a=yPCof4ZbAAAA:8 a=0k35D2EfdJEeNno1514A:9 a=CjuIK1q_8ugA:10 a=7DSvI1NPTFQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 09:57:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes
 for v3.12-rc1
Message-ID: <20130911095734.56e83e9c@gandalf.local.home>
In-Reply-To: <20130911134717.GA10925@phenom.dumpdata.com>
References: <201309110248.r8B2miI2032449@terminus.zytor.com>
	<20130911134717.GA10925@phenom.dumpdata.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 09:47:17 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Tue, Sep 10, 2013 at 07:48:44PM -0700, H. Peter Anvin wrote:

> Which means that all of the arch_spin_unlock (which are inlined) and such
> will now be patched over.
> 
> But perhaps they are not suppose to be enabled in the .smp_prepare_boot_cpu
> function chain? But that seems the best place - as you need to enable
> this before the spinlocks are used on SMP.
> 
> And the IPs are all NOPs.
> 

Note, there was a major conflict with the merge. I need to examine if it
was done correctly. I'm not saying that the bug was caused by the
conflict, it could be because of the change the patch made.

Let me look at the conflict first to verify that it still does what was
intended, then if that looks fine, I'll look into this bug too.

Thanks,

-- Steve
