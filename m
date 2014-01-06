Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaAFUsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:48:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57609 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755815AbaAFUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:48:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        nicolas.pitre@linaro.org
Subject: Re: [PATCH 0/4] CPUFreq stats: Bug fixes
Date: Mon, 06 Jan 2014 22:02:35 +0100
Message-ID: <1555125.bAi9TgavWd@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <cover.1380190886.git.viresh.kumar@linaro.org>
References: <cover.1380190886.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 26, 2013 03:59:50 PM Viresh Kumar wrote:
> Hi Rafael,
> 
> I know you asked me not to send any more patches before the earlier ones get
> into kernel. I got to this as Nicolas Pitre required to send few CPUFreq patches
> for ARM's big LITTLE In-Kernel-Switcher. And within linaro we have hacked these
> bugs in a bad way..
> 
> Because of his dependency I am forced to send these.. These aren't introduced
> recently and so they can be included in 3.13.
> 
> There are several problems/bugs in cpufreq-stats specially with cpufreq drivers
> as modules and suspend/resume path. These are mentioned well in changelogs.
> 
> These are tested over my thinkpad (acpi-cpufreq) in following way:
> [1] offline+online all CPUs except boot cpu in a while loop
> [2] then do suspend resume
> [3] repeat [1] and [2] several times.
> 
> No issues found..
> 
> Also tested on my exynos board:
> - Added cpufreq_unregister/register while loop in exynos-cpufreq.c so that we
>   continuously register/unregister driver... Stats were working fine now..
> - Compile cpufreq-stats as module and insert/remove it several times after
>   removing above hack (as that doesn't let linux boot :) )..
> 
> @Srivatsa: You also have fairly good idea of cpufreq now, so please give some
> time to review this :)
> 
> @Nico: Can you remove the hacky code from IKS tree and test these instead to see
> if we still have any issues?

Can you please rebase this series on top of linux-pm.git/bleeding-edge and
resend it?  Chances are it might make it into 3.14.

Thanks,
Rafael

