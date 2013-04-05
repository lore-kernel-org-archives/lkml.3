Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163074Ab3DEXqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 19:46:16 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:44481 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162968Ab3DEXqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 19:46:15 -0400
Date: Fri, 5 Apr 2013 19:46:04 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@Parags-iMac
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: dirk.brandewie@gmail.com, Adam Williamson <awilliam@redhat.com>,
        Parag Warudkar <parag.lkml@gmail.com>, rjw@sisk.pl,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Subject: Re: [PATCH] cpufreq/intel_pstate: Set timer timeout correctly
In-Reply-To: <CAOh2x=mzQBSnBB3-10yGMdGfxMWeMcvE_t2Mvnz+fvdHv0-uaA@mail.gmail.com>
Message-ID: <alpine.LFD.2.03.1304051943270.3817@gmail.com>
References: <1365096935-16730-1-git-send-email-dirk.brandewie@gmail.com> <CAOh2x=mzQBSnBB3-10yGMdGfxMWeMcvE_t2Mvnz+fvdHv0-uaA@mail.gmail.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Apr 2013, Viresh Kumar wrote:

> On Thu, Apr 4, 2013 at 11:05 PM,  <dirk.brandewie@gmail.com> wrote:
> > From: Dirk Brandewie <dirk.brandewie@gmail.com>
> >
> > The current calculation of the delay time is wrong and a cut and paste
> > error from a previous experimental driver.  This can result in the
> > timeout being set to jiffies + 1 which setup the driver to race with
> > it's self if the apic timer interrupt happen at just the right time.
> >
> >
> > https://bugzilla.redhat.com/show_bug.cgi?id=920289
> >
> > Reported-by: Adam Williamson <awilliam@redhat.com>
> > Reported-by: Parag Warudkar <parag.lkml@gmail.com>
> >
> > Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> > ---
> >  drivers/cpufreq/intel_pstate.c |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> Looks fine, but I would like to see a Tested-by from Adam/Parag
> as they haven't said anything about this patch (even in bugzilla).
> 

I am running with the patch since yesterday - everything looks good.

The issue hasn't been reproducible on demand but some code reading and 
Dirk's explanation says the patch should fix the issue.

So - Tested-by: Parag Warudkar <parag.lkml@gmail.com>

Parag
