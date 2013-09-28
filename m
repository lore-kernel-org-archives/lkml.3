Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab3I1KXP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 06:23:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59384 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab3I1KXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 06:23:11 -0400
Date: Sat, 28 Sep 2013 12:23:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Cleanup boot CPUs table
Message-ID: <20130928102305.GA5956@pd.tnic>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927103802.GA4422@pd.tnic>
 <20130927143249.GD4422@pd.tnic>
 <20130927143554.GF4422@pd.tnic>
 <20130928082542.GA18198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130928082542.GA18198@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 10:25:42AM +0200, Ingo Molnar wrote:
> Could we, with another add-on patch, further compress the first half
> of the output as well?
>
> Advanced output like this would be really cool:

Sure.

> > [    0.074509] x86: Booting node #0, CPUs:       #1  #2  #3  #4  #5  #6  #7
> > [    0.644008] x86: Booting node #1, CPUs:   #8  #9 #10 #11 #12 #13 #14 #15
> > [    1.245006] x86: Booting node #2, CPUs:  #16 #17 #18 #19 #20 #21 #22 #23
> > [    1.864005] x86: Booting node #3, CPUs:  #24 #25 #26 #27 #28 #29 #30 #31
> > [    2.489005] x86: Booting node #4, CPUs:  #32 #33 #34 #35 #36 #37 #38 #39
> > [    3.093005] x86: Booting node #5, CPUs:  #40 #41 #42 #43 #44 #45 #46 #47
> > [    3.698005] x86: Booting node #6, CPUs:  #48 #49 #50 #51 #52 #53 #54 #55
> > [    4.304005] x86: Booting node #7, CPUs:  #56 #57 #58 #59 #60 #61 #62 #63
> > [    4.961413] x86: Booted up 8 nodes, 64 CPUs

Boot(ing|ed) kinda wastes unnecessary space too, how about we go a step
further:

[    0.074509] x86: Booting SMP configuration:
[    0.644008] .... node #0, CPUs:       #1  #2  #3  #4  #5  #6  #7
[    1.245006] .... node #1, CPUs:   #8  #9 #10 #11 #12 #13 #14 #15
[    1.864005] .... node #2, CPUs:  #16 #17 #18 #19 #20 #21 #22 #23
[    2.489005] .... node #3, CPUs:  #24 #25 #26 #27 #28 #29 #30 #31
[    3.093005] .... node #4, CPUs:  #32 #33 #34 #35 #36 #37 #38 #39
[    3.698005] .... node #5, CPUs:  #40 #41 #42 #43 #44 #45 #46 #47
[    4.304005] .... node #6, CPUs:  #48 #49 #50 #51 #52 #53 #54 #55
[    4.961413] .... node #7, CPUs:  #56 #57 #58 #59 #60 #61 #62 #63
[    5.245021] x86: Booted up 8 nodes, 64 CPUs

> > [    0.072367] x86: Booting node #0, CPUs:     #1 #2 #3 #4 #5 #6 #7 
> > [    0.686329] x86: Booted up 1 node, 8 CPUs

vs

[    0.074509] x86: Booting SMP configuration:
[    0.072367] .... node #0, CPUs:     #1 #2 #3 #4 #5 #6 #7
[    0.686329] x86: Booted up 1 node, 8 CPUs

Btw, the "x86" prefix would mean we want to either change pr_fmt() of
arch/x86/kernel/smpboot.c (which I rather not) or not use pr_info (which
I'd prefer).

> Note the typographical details I added:
> 
>   - I added an extra space after 'CPUs:' to make the table stand out 
>     better from far away

Ok.

>   - Removed the 'OK' - it really does not add any more information than
>     the newline already does

Yes.

>   - Changed the 'Brought up' message to be more consistent with the prior
>     messages.

Ok.

>   - Added nodes count to the 'Booted up' line. Since we count nodes and
>     CPUs, we might as well want to demonstrate our superior counting
>     skills and print out both.

Haha, ok.

>   - The 'node' counting uses the new num_digits() function - this was very
>     easy to implement in my mockup ;-)

Ok.

>   - Note the singular spelling of 'node' in the 1-node case. Again this 
>     was easy in the mockup!

Should be easy to do :)

So how about the even shorter mockup above?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
