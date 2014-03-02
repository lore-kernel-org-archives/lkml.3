Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaCBVmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:42:36 -0500
Received: from mail.wdtv.com ([66.118.69.84]:57369 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaCBVme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:42:34 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
Date: Sun, 2 Mar 2014 16:42:32 -0500
References: <20140228140043.GA12157@debian.local> <20140302205619.GA8676@rhlx01.hs-esslingen.de> <20140302210201.GA31948@redhat.com>
In-Reply-To: <20140302210201.GA31948@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201403021642.33087.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 March 2014, Dave Jones wrote:
>On Sun, Mar 02, 2014 at 09:56:19PM +0100, Andreas Mohr wrote:
> > (BTW, would it be possible to transform Linux's PAE support into
> > boot-config or even fully runtime-detectable boot switching to
> > (non-)PAE, similar to or exceeding what XP offers with its static
> > boot-time flag?
> > Last time I checked PAE support config defines were spread over ~ 40
> > kernel source files though :-((()
>
>It would be a considerable amount of work to make it a runtime thing.
>Ten years ago, maybe it would be worth the effort perhaps, but I'd
>suggest just letting 32-bit slowly die instead of doing dramatic
>overhauls that will no doubt introduce a bunch of regressions in code
>that's been notoriously awful to debug issues in during the past.
>
>	Dave

There is a fly in that soup Dave, and that is the speed in a truly real 
time required environment.  IRQ latencies once the 32 bit scene have been 
left behind, either by PAE or a full 64 bit build are not at all well 
defined, and are of sufficient magnitudes in terms of the timing jitter, as 
to nearly destroy our ability to use software step generation to control 
our machine tools.  A motor being stepped every 200 microseconds (thats 
actually slow) will lose 50% of its available torque if the timing jitter 
in the step issuance is 10% of the period.

We routinely expect 2 to 3 u-s jitters on an Atom board running a 32 bit, 
RTAI enhanced build of what is by now a 5 year old kernel.  This is 
extremely board sensitive, and that same kernel running on this 4 core 
phenom, cannot stay inside of 40 u-s.  A case of more horsepower not being 
a good deal at all.

OTOH, we (LinuxCNC) are a very small user group. I just want to make you 
aware that we exist. We do retrofits mostly, because our software can make 
the part faster, but I would estimate there are 5 to 10k machines out there 
in the major manufacturing scene running our software, and that they 
include some of the heaviest hitters in the auto making business.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

