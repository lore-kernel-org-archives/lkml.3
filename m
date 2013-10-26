Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3JZIkl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 04:40:41 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:36957 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab3JZIki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 04:40:38 -0400
Date: Sat, 26 Oct 2013 10:40:33 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131026084033.GA14237@gmail.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-4-git-send-email-treding@nvidia.com>
 <20131025132553.GE9999@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025132553.GE9999@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Will Deacon <will.deacon@arm.com> wrote:

> On Fri, Oct 25, 2013 at 02:03:42PM +0100, Thierry Reding wrote:
> > Today's linux-next merge of the tip tree got conflicts in
> > 
> >         tools/perf/config/Makefile
> >         tools/perf/config/feature-tests.mak
> > 
> > caused by commits 405ffbd (perf tools: Check libunwind for availability of
> > dwarf parsing feature) and mostly 308e1e7 (tools/perf/build: Clean up the
> > libunwind logic in config/Makefile) as well as various follow-up patches.
> > 
> > I fixed it up (see below). Please verify that the resolution looks good.
> > Also note that this isn't really a trivial resolution of a conflict, but
> > required modifying various other files. That causes rerere magic not to
> > work and needs part of conflict to be resolved manually. Perhaps a good
> > idea would be to rebase Jean's patch on top of the cleanups going on in
> > the tip tree? Perhaps even carry the patch in the tip tree?
> 
> These came via my tree (arm perf) after discussion here:
> 
>   http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/203077.html
> 
> Now that they've been pulled by rmk, we can't back them out with 
> ugly reverts, so I'm not sure what we can do to resolve in the ARM 
> tree; it looks like the perf Makefile has changed significantly in 
> -tip.

I realize that it was acked by Arnaldo, but for workflow reasons I'd 
really prefer it if non-trivial perf tooling patches went to Arnaldo 
as a pull request so that he can resolve any such conflicts. perf is 
in constant development so it's less work for you that way.

(Kernel side changes can go that route as well, as long as they are 
perf related.)

Thanks,

	Ingo
