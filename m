Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3A2IMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 03:12:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63997 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab3A2IMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 03:12:08 -0500
Date: Tue, 29 Jan 2013 09:12:03 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Valdis.Kletnieks@vt.edu
Cc: ling.ma.program@gmail.com, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        Ma Ling <ling.ml@alipay.com>
Subject: Re: [PATCH] [x86]: Compiler Option Os is better on latest x86
Message-ID: <20130129081203.GD594@gmail.com>
References: <1359123061-6139-1-git-send-email-ling.ma@alipay.com>
 <26437.1359393357@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26437.1359393357@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Fri, 25 Jan 2013 09:11:01 -0500, ling.ma.program@gmail.com said:
> 
> > Based on above reasons, we compiled linux kernel 3.6.9 with O2 and Os
> > respectively. The results show Os improve performance netperf 4.8%,
> > 2.7% for volano as below
> 
> Am I allowed to NAK this?  What the numbers given so far 
> *actually* show is 4.8% more instructions executed, *not* 4.8% 
> better performance.

cycles and elapsed time is down in both tests - the speedup 
seems statistically a wash in the first test and significant for 
the second workload.

the instruction count might be an artifact of byte wise versus 
word wise REP; MOV.

> I'm having a *very* hard time convincing myself that what 
> we're seeing isn't simply the expected behavior of loops *not* 
> being unrolled and similar non-optimizations done by -Os, so 
> more instructions get executed to do the same amount of work.
> 
> Rather than "run for 10 seconds and count instructions", can 
> we "run for 50,000 syscalls and count clock time" or similar 
> that shows an *actual* improvement?

Look at the numbers, it counts a whole lot of other things as 
well beyond instructions - elapsed time being the most important 
one.

But more numbers never hurt.

Thanks,

	Ingo
