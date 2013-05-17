Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab3EQJzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 05:55:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56287 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749Ab3EQJzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 05:55:06 -0400
Date: Fri, 17 May 2013 10:54:23 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Bug] ARM 'perf' regression by commit a43cb95d5
Message-ID: <20130517095423.GD23112@mudshark.cambridge.arm.com>
References: <CACVXFVPjo2dQpYPpqZS8GC8UPNzB5HLURpYm6-g1FOBbSUjDyA@mail.gmail.com>
 <20130517085530.GB22992@mudshark.cambridge.arm.com>
 <CACVXFVPEBXat3bPPuHzV535=xLoRMFd03Kjzp=NUF5E3KCq2=g@mail.gmail.com>
 <20130517093616.GC23112@mudshark.cambridge.arm.com>
 <CACVXFVP56EJb0BZ+w6hVAukQ-mN0e0Jn_GLw3XqXQqMwVGfNdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVP56EJb0BZ+w6hVAukQ-mN0e0Jn_GLw3XqXQqMwVGfNdA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:48:23AM +0100, Ming Lei wrote:
> On Fri, May 17, 2013 at 5:36 PM, Will Deacon <will.deacon@arm.com> wrote:
> >
> > It's probably easier if you choose a workload, otherwise it's difficult to
> > see what is `correct' and what is broken. For example, your broken output
> > seems to be in the smsc95xx driver, so assumedly there's a bunch of
> > networking going on whereas your other output is in cpuidle_enter_state.
> 
> If all modules are removed, the result will become OK. And if I only insert one
> module, the top sample will fall inside the only module, but I am sure
> nothing is working on the symbols of the module.

Can you check your dmesg please? I suppose the smsc95xx driver might be
screaming about something and somehow the changes to the reg printing have
made it get stuck.

> >
> > We need an apples-for-apples comparison if you think there's a bug in the
> > kernel. Can you try profiling hackbench or something?
> >
> >> Or could anyone else try to verify the problem on their own environment?
> >
> > How are you running perf top?
> 
> sudo perf top

... and did hackbench make any difference (i.e. is the profile more stable)?

Will
