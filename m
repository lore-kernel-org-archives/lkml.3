Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3BZKo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 05:44:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3BZKo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 05:44:26 -0500
From: Thomas Renninger <trenn@suse.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com
Subject: Re: [RFC] cpufreq: governor: Set MIN_LATENCY_MULTIPLIER to 20
Date: Tue, 26 Feb 2013 11:44:19 +0100
Message-ID: <1993068.XZh8f6yGqe@skinner.arch.suse.de>
Organization: SUSE Products GmbH
User-Agent: KMail/4.10 (Linux/3.7.7-1.2-desktop; KDE/4.10.0; x86_64; ; )
In-Reply-To: <472e2bac1fc4a2589651beddbfaf6da53500d12e.1361871582.git.viresh.kumar@linaro.org>
References: <472e2bac1fc4a2589651beddbfaf6da53500d12e.1361871582.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 26, 2013 03:13:32 PM Viresh Kumar wrote:
> Currently MIN_LATENCY_MULTIPLIER is set defined as 100 and so on a system
> with transition latency of 1 ms, the minimum sampling time comes to be
> around 100 ms. That is quite big if you want to get better performance for
> your system.
> 
> Redefine MIN_LATENCY_MULTIPLIER to 20 so that we can support 20ms sampling
> rate for such platforms.

Redefining MIN_LATENCY_MULTIPLIER shouldn't hurt that much, but this looks
like a workaround.
It only modifies the minimal sampling rate that userspace can set.
You would still need to set something from userspace to get the perfect 
sampling rate for this platform.

I wonder where the cpufreq driver does get the 1ms latency from?
Is this value valid?
The driver should return the correct latency, then there is no need for
workarounds like this.

      Thomas
