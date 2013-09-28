Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab3I1IZt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:25:49 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40847 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab3I1IZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:25:46 -0400
Date: Sat, 28 Sep 2013 10:25:42 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Cleanup boot CPUs table
Message-ID: <20130928082542.GA18198@gmail.com>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927103802.GA4422@pd.tnic>
 <20130927143249.GD4422@pd.tnic>
 <20130927143554.GF4422@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130927143554.GF4422@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> From: Borislav Petkov <bp@suse.de>
> 
> As the new x86 CPU bootup printout format code maintainer, I am taking
> immediate action to improve and clean (and thus indulge my OCD) the
> reporting of the cores when coming up online.
> 
> Fix padding to a right-hand alignment, cleanup code and bind reporting
> width to the max number of supported CPUs on the system, like this:
> 
> [    0.074509] smpboot: Booting Node   0, Processors:      #1  #2  #3  #4  #5  #6  #7 OK
> [    0.644008] smpboot: Booting Node   1, Processors:  #8  #9 #10 #11 #12 #13 #14 #15 OK
> [    1.245006] smpboot: Booting Node   2, Processors: #16 #17 #18 #19 #20 #21 #22 #23 OK
> [    1.864005] smpboot: Booting Node   3, Processors: #24 #25 #26 #27 #28 #29 #30 #31 OK
> [    2.489005] smpboot: Booting Node   4, Processors: #32 #33 #34 #35 #36 #37 #38 #39 OK
> [    3.093005] smpboot: Booting Node   5, Processors: #40 #41 #42 #43 #44 #45 #46 #47 OK
> [    3.698005] smpboot: Booting Node   6, Processors: #48 #49 #50 #51 #52 #53 #54 #55 OK
> [    4.304005] smpboot: Booting Node   7, Processors: #56 #57 #58 #59 #60 #61 #62 #63 OK
> [    4.961413] Brought up 64 CPUs

Awesome!

Could we, with another add-on patch, further compress the first half of 
the output as well?

Advanced output like this would be really cool:

> [    0.074509] x86: Booting node #0, CPUs:       #1  #2  #3  #4  #5  #6  #7
> [    0.644008] x86: Booting node #1, CPUs:   #8  #9 #10 #11 #12 #13 #14 #15
> [    1.245006] x86: Booting node #2, CPUs:  #16 #17 #18 #19 #20 #21 #22 #23
> [    1.864005] x86: Booting node #3, CPUs:  #24 #25 #26 #27 #28 #29 #30 #31
> [    2.489005] x86: Booting node #4, CPUs:  #32 #33 #34 #35 #36 #37 #38 #39
> [    3.093005] x86: Booting node #5, CPUs:  #40 #41 #42 #43 #44 #45 #46 #47
> [    3.698005] x86: Booting node #6, CPUs:  #48 #49 #50 #51 #52 #53 #54 #55
> [    4.304005] x86: Booting node #7, CPUs:  #56 #57 #58 #59 #60 #61 #62 #63
> [    4.961413] x86: Booted up 8 nodes, 64 CPUs

and:

> [    0.072367] x86: Booting node #0, CPUs:     #1 #2 #3 #4 #5 #6 #7 
> [    0.686329] x86: Booted up 1 node, 8 CPUs

Note the typographical details I added:

  - I added an extra space after 'CPUs:' to make the table stand out 
    better from far away

  - Removed the 'OK' - it really does not add any more information than
    the newline already does

  - Changed the 'Brought up' message to be more consistent with the prior
    messages.

  - Added nodes count to the 'Booted up' line. Since we count nodes and
    CPUs, we might as well want to demonstrate our superior counting
    skills and print out both.

  - The 'node' counting uses the new num_digits() function - this was very
    easy to implement in my mockup ;-)

  - Note the singular spelling of 'node' in the 1-node case. Again this 
    was easy in the mockup!

Thanks,

	Ingo
