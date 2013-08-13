Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3HMKs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:48:27 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:36939 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214Ab3HMKsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:48:25 -0400
Date: Tue, 13 Aug 2013 12:48:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>, Namhyung Kim <namhyung.kim@lge.com>,
        peterz@infradead.org
Subject: Re: [PATCH] RFC: perf, tools: Move gtk browser into separate perfgtk
 executable
Message-ID: <20130813104821.GB2170@gmail.com>
References: <1375669364-13838-1-git-send-email-andi@firstfloor.org>
 <20130805081641.GA24808@gmail.com>
 <20130805082320.GA9562@infradead.org>
 <20130805083132.GE26746@gmail.com>
 <20130805083434.GA20606@infradead.org>
 <20130805090857.GA26940@gmail.com>
 <20130806061932.GA20485@infradead.org>
 <20130812181956.GB19405@gmail.com>
 <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1308121521170.25956@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

> On Mon, 12 Aug 2013, Ingo Molnar wrote:
> 
> > perf is the exact opposite: no split-up the development culture 
> > because they are closely related, yet a relatively disciplined ABI 
> > between the components. In fact the ABI is higher quality exactly 
> > because development is more integrated and allows for ABI problems to 
> > be resolved before they leak out. It also allows for faster iteration 
> > of development, without nonsensical ABI steps pulluting the way.
> 
> I don't know if I'd use "quality" and "perf ABI" in the same sentence. 
> It's a horrible ABI; it has the honor of having the longest syscall 
> manpage, beating out even ptrace.

The functionality it provides is useful, and comprehensive documentation 
of it is useful as well.

> It also really isn't that stable; I've had perf ABI changes break 
> programs I maintain at least three times in the last 2 kernel releases.  
> Part of this is due to the tight coupling into the kernel, in fact the 
> only ABI anyone seems to care about is that presented by the perf-tool 
> CLI interface; the _actual_ kernel ABI seems like an afterthought.

It's certainly complex, but the main root cause for your problems is what 
I pointed out to you in previous, similar discussions: I'm not aware of 
*any* tester using your library on devel kernels, so regressions in seldom 
used functionality that you rely on simply doesn't get reported.

In the past you used to only test your library once the -stable kernel was 
released - has this changed recently by any chance? I remember that in one 
particular case I got a regression bugreport from you essentially on the 
day of a -stable release.

If you tested -rc2 or so that would give us a much larger window to fix 
any breakages that affect your library. (I'm not even asking for 
linux-next testing.)

tools/perf is used much more prominently and breakages do get reported 
reasonably early, typically before the merge window even opens.

Once we receive a report we do fix your regressions as well and mark them 
for -stable.

To resolve this situation you could help us out by doing either of these:

 1) integrate your tests into tools/, there's 'perf test' that has a ton
    of testcases already

 2) run your testsuite more frequently - instead of waiting for a stable
    kernel to be released and then complain about breakage.

So far you refused to do any of this and blamed others for non-reported 
breakages :-/

Thanks,

	Ingo
