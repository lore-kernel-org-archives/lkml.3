Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab3IJBfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 21:35:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39935 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab3IJBfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 21:35:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-pm@vger.kernel.org
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-sh@vger.kernel.org,
        Magnus Damm <magnus.damm@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers" breaks cpufreq too
Date: Tue, 10 Sep 2013 03:46:35 +0200
Message-ID: <2529974.gUYIkmlmP8@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2339390.oQAxMuU2Y5@vostro.rjw.lan>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange> <Pine.LNX.4.64.1309092330560.12376@axis700.grange> <2339390.oQAxMuU2Y5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 10, 2013 01:12:49 AM Rafael J. Wysocki wrote:
> On Monday, September 09, 2013 11:42:41 PM Guennadi Liakhovetski wrote:
> > Hi Rafael
> > 
> > On Mon, 9 Sep 2013, Rafael J. Wysocki wrote:
> > 
> > > Hi,
> > > 
> > > On Monday, September 09, 2013 05:11:10 PM Guennadi Liakhovetski wrote:
> > > > Sorry guys, I'm trying my best to stop this patch from propagating to 
> > > > stable and to get it fixed asap, so, the CC list might be a bit excessive. 
> > > > Also trying to fix the originally spare cc list, which makes it impossible 
> > > > for me to reply to the original thread, instead have to start a new one.
> > > 
> > > I'm not sure what you're talking about.  What exactly was wrong with the
> > > original CC list in particular?
> > 
> > I think you advised once to cc cpufreq related mails to linux-pm too at 
> > least.
> 
> Yes, I did.
> 
> > I haven't found this patch in my pm archive, have I missed it there?
> 
> Quite frankly, I don't remember if it was there.  ISTR having it it patchwork,
> which would mean that it was there, but well.
> 
> > > > Commit
> > > > 
> > > > commit dceff5ce18801dddc220d6238628619c93bc3cb6
> > > > Author: Viresh Kumar <viresh.kumar@linaro.org>
> > > > Date:   Sun Sep 1 22:19:37 2013 +0530
> > > > 
> > > >     cpufreq: fix serialization issues with freq change notifiers
> > > > 
> > > > breaks .transition_ongoing counting.
> > > 
> > > Do you know how exactly it breaks that?  If so, care to share that knowledge?
> > 
> > No, I don't. I only know that in __cpufreq_driver_target() the check for
> > 
> > 	if (policy->transition_ongoing) {
> > 		write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > 		return -EBUSY;
> > 	}
> > 
> > is failing with this patch and cpufreq-cpu0.
> 
> OK, we need to figure out that, then.

But given the timing I think I'll just start to revert things and we can add
them back later after we've sorted out all problems.

So I'm going to drop commit dceff5c from the linux-next branch and I'm going to
revert commit 7c30ed5 along with commit 266c13d that tried to fix it and we'll
revisit the transition serialization issue when we really know how to fix it.

Thanks,
Rafael

