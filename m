Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762480Ab3IEAPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 20:15:20 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:58118 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab3IEAPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 20:15:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
Date: Thu, 05 Sep 2013 02:26:10 +0200
Message-ID: <16630296.tCCMEKstkO@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5227C729.5040803@codeaurora.org>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <1706734.hVYFTCa5rJ@vostro.rjw.lan> <5227C729.5040803@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 04, 2013 04:50:01 PM Stephen Boyd wrote:
> On 09/04/13 16:55, Rafael J. Wysocki wrote:
> >
> > Well, I'm not sure when Viresh is going to be back.
> >
> > Srivatsa, can you please resend this patch with a proper changelog?
> >
> 
> I haven't had a chance to try this out yet, but I was just thinking
> about this patch. How is it going to work? If one task opens the file
> and another task is taking down the CPU wouldn't we deadlock in the
> CPU_DOWN notifier waiting for the kobject to be released? Task 1 will
> grab the kobject reference and sleep on the hotplug mutex and task 2
> will put the kobject and wait for the completion, but it won't happen.
> At least I think that's what would happen.

Do you mean the completion in sysfs_deactivate()?  Yes, we can deadlock
there.

Well, I guess the Srivatsa's patch may be salvaged by making it do a "trylock"
version of get_online_cpus(), but then I wonder if there's no better way.

Thanks,
Rafael

