Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3HMOCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:02:47 -0400
Received: from smtpauth05.mfg.siteprotect.com ([64.26.60.144]:44829 "EHLO
	smtpauth05.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755291Ab3HMOCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:02:46 -0400
Date: Tue, 13 Aug 2013 10:03:52 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Ingo Molnar <mingo@kernel.org>
cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
In-Reply-To: <20130813104821.GB2170@gmail.com>
Message-ID: <alpine.DEB.2.02.1308130955360.4537@pianoman.cluster.toy>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org> <20130805081641.GA24808@gmail.com> <20130805082320.GA9562@infradead.org> <20130805083132.GE26746@gmail.com> <20130805083434.GA20606@infradead.org> <20130805090857.GA26940@gmail.com>
 <20130806061932.GA20485@infradead.org> <20130812181956.GB19405@gmail.com> <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy> <20130813104821.GB2170@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020202.520A3C85.01D0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013, Ingo Molnar wrote:
> * Vince Weaver <vince@deater.net> wrote:

> In the past you used to only test your library once the -stable kernel was 
> released - has this changed recently by any chance? I remember that in one 
> particular case I got a regression bugreport from you essentially on the 
> day of a -stable release.
> 
> If you tested -rc2 or so that would give us a much larger window to fix 
> any breakages that affect your library. (I'm not even asking for 
> linux-next testing.)

I wasn't aware that the Linux "no-ABI breakage guarantee" only applied to 
people who ran -rc kernels.

I've spent a lot of time enhancing trinity and writing my own perf syscall 
fuzzer just to try to keep on top of ABI breaks as per your rules and they 
still slip in and they still don't get reverted.

In any case, a list of perf-related ABI breakages is here.
 http://web.eece.maine.edu/~vweaver/projects/perf_events/abi_breakage.html
I guess whether it's a lot or just a few depends on your perspective.

> To resolve this situation you could help us out by doing either of these:
> 
>  1) integrate your tests into tools/, there's 'perf test' that has a ton
>     of testcases already

I have enough trouble keeping my code up to date let alone wasting weeks 
of time re-sending patches.  Some things are just simpler to maintain 
outside the kernel.

>  2) run your testsuite more frequently - instead of waiting for a stable
>     kernel to be released and then complain about breakage.

I only have so many machines and so much time, and no one is funding me 
for this work.  I run -rc kernels when I can, but perf can be very 
architecture and even CPU dependent so it is hard to get full coverage.  
For example it's hard to test full SNB-EP uncore support w/o such a 
machine.

Vince
