Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3I1No5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:44:57 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45284 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3I1Nox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:44:53 -0400
Date: Sat, 28 Sep 2013 15:44:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Cleanup boot CPUs table
Message-ID: <20130928134449.GB26931@gmail.com>
References: <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927103802.GA4422@pd.tnic>
 <20130927143249.GD4422@pd.tnic>
 <20130927143554.GF4422@pd.tnic>
 <20130928082542.GA18198@gmail.com>
 <20130928102305.GA5956@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130928102305.GA5956@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Sep 28, 2013 at 10:25:42AM +0200, Ingo Molnar wrote:
> > Could we, with another add-on patch, further compress the first half
> > of the output as well?
> >
> > Advanced output like this would be really cool:
> 
> Sure.
> 
> > > [    0.074509] x86: Booting node #0, CPUs:       #1  #2  #3  #4  #5  #6  #7
> > > [    0.644008] x86: Booting node #1, CPUs:   #8  #9 #10 #11 #12 #13 #14 #15
> > > [    1.245006] x86: Booting node #2, CPUs:  #16 #17 #18 #19 #20 #21 #22 #23
> > > [    1.864005] x86: Booting node #3, CPUs:  #24 #25 #26 #27 #28 #29 #30 #31
> > > [    2.489005] x86: Booting node #4, CPUs:  #32 #33 #34 #35 #36 #37 #38 #39
> > > [    3.093005] x86: Booting node #5, CPUs:  #40 #41 #42 #43 #44 #45 #46 #47
> > > [    3.698005] x86: Booting node #6, CPUs:  #48 #49 #50 #51 #52 #53 #54 #55
> > > [    4.304005] x86: Booting node #7, CPUs:  #56 #57 #58 #59 #60 #61 #62 #63
> > > [    4.961413] x86: Booted up 8 nodes, 64 CPUs
> 
> Boot(ing|ed) kinda wastes unnecessary space too, how about we go a step
> further:
> 
> [    0.074509] x86: Booting SMP configuration:
> [    0.644008] .... node #0, CPUs:       #1  #2  #3  #4  #5  #6  #7
> [    1.245006] .... node #1, CPUs:   #8  #9 #10 #11 #12 #13 #14 #15
> [    1.864005] .... node #2, CPUs:  #16 #17 #18 #19 #20 #21 #22 #23
> [    2.489005] .... node #3, CPUs:  #24 #25 #26 #27 #28 #29 #30 #31
> [    3.093005] .... node #4, CPUs:  #32 #33 #34 #35 #36 #37 #38 #39
> [    3.698005] .... node #5, CPUs:  #40 #41 #42 #43 #44 #45 #46 #47
> [    4.304005] .... node #6, CPUs:  #48 #49 #50 #51 #52 #53 #54 #55
> [    4.961413] .... node #7, CPUs:  #56 #57 #58 #59 #60 #61 #62 #63
> [    5.245021] x86: Booted up 8 nodes, 64 CPUs
>
> 
> [    0.074509] x86: Booting SMP configuration:
> [    0.072367] .... node #0, CPUs:     #1 #2 #3 #4 #5 #6 #7
> [    0.686329] x86: Booted up 1 node, 8 CPUs

Nice!

> Btw, the "x86" prefix would mean we want to either change pr_fmt() of
> arch/x86/kernel/smpboot.c (which I rather not) or not use pr_info (which
> I'd prefer).

Not using pr_info() for such specially formatted output is fine I think.

Thanks,

	Ingo
