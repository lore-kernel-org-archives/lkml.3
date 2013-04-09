Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500Ab3DISnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:43:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:48942 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761628Ab3DISno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:43:44 -0400
Date: Tue, 9 Apr 2013 20:43:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@sr71.net>
cc: Borislav Petkov <bp@alien8.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
In-Reply-To: <516439DF.3050901@sr71.net>
Message-ID: <alpine.LFD.2.02.1304092036431.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

On Tue, 9 Apr 2013, Dave Hansen wrote:

> Hey Thomas,
> 
> I don't think the patch helped my case.  Looks like the same BUG_ON().
> 
> I accidentally booted with possible_cpus=10 instead of 160.  I wasn't
> able to trigger this in that case, even repeatedly on/offlining them.
> But, once I booted with possible_cpus=160, it triggered in a jiffy.

Darn. We should have merged Paul McKenneys NR_CPUS=0 patch last year
and we would have avoided the whole shebang.
 
> > [  161.551788] smpboot_thread_fn():
> > [  161.551807] td->cpu: 132
> > [  161.551808] smp_processor_id(): 121
> > [  161.551811] comm: migration/%u
> > [  161.551840] ------------[ cut here ]------------
> > [  161.551939] kernel BUG at kernel/smpboot.c:149!

Any chance, that you get a trace for that?

Thanks,

	tglx

