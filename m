Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaCFMPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 07:15:46 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51406 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751676AbaCFMPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 07:15:45 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Plattner <aplattner@nvidia.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: use cpufreq_cpu_get to avoid cpufreq_get race conditions
Date: Thu, 06 Mar 2014 13:30:57 +0100
Message-ID: <2112618.kABuM8MuMA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5317CBF2.40908@nvidia.com>
References: <1393965735-15610-1-git-send-email-aplattner@nvidia.com> <2327882.a9zobM63G6@vostro.rjw.lan> <5317CBF2.40908@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 05, 2014 05:14:26 PM Aaron Plattner wrote:
> On 03/05/14 17:23, Rafael J. Wysocki wrote:
> > On Tuesday, March 04, 2014 12:42:15 PM Aaron Plattner wrote:
> >> If a module calls cpufreq_get while cpufreq is initializing, it's possible for
> >> it to be called after cpufreq_driver is set but before cpufreq_cpu_data is
> >> written during subsys_interface_register.  This happens because cpufreq_get
> >> doesn't take the cpufreq_driver_lock around its use of cpufreq_cpu_data.
> >
> > Is this a theoretical race, or can you actually reproduce it?  If so, on what
> > system/driver?  Or are there any bug reports related to this you can point me
> > to?
> 
> It reproduces on my Arch Linux system at home with the nvidia driver, 
> and there has been at least one bug report that looks like the same thing:
> 
> https://bbs.archlinux.org/viewtopic.php?id=177934
> 
> I reproduced the problem with v3.13.5, then applied this change and was 
> able to boot successfully 10/10 times.  So I guess that means you can add
> 
> Tested-by: Aaron Plattner <aplattner@nvidia.com>

Tested-by is not needed if you're the author.

Everybody should test their patches, right? ;-)

I'll mark it for 3.13-stable and add the link above to the changelog.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
