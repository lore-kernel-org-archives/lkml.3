Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173Ab3BZMZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:25:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab3BZMZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:25:03 -0500
From: Thomas Renninger <trenn@suse.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Subject: Re: [RFC] cpufreq: governor: Set MIN_LATENCY_MULTIPLIER to 20
Date: Tue, 26 Feb 2013 13:24:57 +0100
Message-ID: <1457024.oessUW7SMx@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.7-1.2-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <CAKohpomt+7YtD5s+XJ5-boCu_atCB0kHhuifWOGVwy7DqnBLPA@mail.gmail.com>
References: <472e2bac1fc4a2589651beddbfaf6da53500d12e.1361871582.git.viresh.kumar@linaro.org> <1993068.XZh8f6yGqe@skinner.arch.suse.de> <CAKohpomt+7YtD5s+XJ5-boCu_atCB0kHhuifWOGVwy7DqnBLPA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 26, 2013 04:20:07 PM Viresh Kumar wrote:
> On 26 February 2013 16:14, Thomas Renninger <trenn@suse.de> wrote:
> > Redefining MIN_LATENCY_MULTIPLIER shouldn't hurt that much, but this looks
> > like a workaround.
> > It only modifies the minimal sampling rate that userspace can set.
> 
> Yes.
> 
> > You would still need to set something from userspace to get the perfect
> > sampling rate for this platform.
> 
> Yes. We still need to fix sampling rate from userspace.
> 
> > I wonder where the cpufreq driver does get the 1ms latency from?
> > Is this value valid?
> > The driver should return the correct latency, then there is no need for
> > workarounds like this.
> 
> I am talking about ARM Vexpress TC2 (Test Chip) big LITTLE SoC here. Its
> not a production type SoC and freq change is a bit slow here. Its really
> around 1 ms :)
> 
> But the real systems may not have this big of latency.
> 
> Anyway, how do you come to 100 value in your initial patch. What motivated
> you to fix it there?
Iirc there were two things:
   - max latency does not make any sense at all and it got reverted
   - min latency makes some sense -> prevent a system to get unresponsive
     due to too small sampling rate forced by userspace.
     I reduced the min_sampling rate calculation to better be able to test
     best sampling rate values by trying them out.

But I agree, that it should not harm to lower the MIN_LATENCY_MULTIPLIER.
In fact it doesn't change anything as long as userspace does not override
the sample factor and the system should still not stall (this is what the 
min_sampling_rate tries to prevent).

So from what you describe above:
This patch makes sense, especially to test and debug some early HW where
latency values might be big (or bogus). Then the developer can still enforce
lower polling rates, but they can still not be that low that userspace is able 
to stall the system.

No objections from my side if this patch helps you to get further.

   Thomas
