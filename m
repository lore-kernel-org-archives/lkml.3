Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab3AKWeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:34:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38231 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab3AKWeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:34:17 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/5] cpufreq: handle SW coordinated CPUs
Date: Fri, 11 Jan 2013 23:40:04 +0100
Message-ID: <1629581.g1KDRlRfi1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
References: <1353947996-26723-1-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 26, 2012 05:39:51 PM Fabio Baltieri wrote:
> Hello Rafael,
> 
> this patchset is a new version of the cpufreq SW coordinated CPU bug fix.
> That's basically the v4 rebased on linux-pm's linux-next tree, split in 5
> patches for readability and with the bug fixed also in the "conservative"
> governor.
> 
> Regards,
> Fabio
> 
> 
> Changes:
> v5
> - rebased/reimplemented on linux-next
> - split hotplug code on a separate patch
> - split ondemand/conservative specific fixes on separate patches
> v4
> - moved update_sampling rate code on separate patch
> - simplified dbs_sw_coordinated_cpus
> - reworked timer handling for code readability, now:
>   * do_dbs_timer() [-> dbs_timer_coordinated()] -> dbs_timer_update()
> - simplified cpu_callback cases
> v3
> - original submission
> 
> 
> Fabio Baltieri (4):
>   cpufreq: star/stop cpufreq timers on cpu hotplug
>   cpufreq: ondemand: call dbs_check_cpu only when necessary
>   cpufreq: conservative: call dbs_check_cpu only when necessary
>   cpufreq: ondemand: use all CPUs in update_sampling_rate
> 
> Rickard Andersson (1):
>   cpufreq: handle SW coordinated CPUs
> 
>  drivers/cpufreq/cpufreq_conservative.c |  46 ++++++++++++--
>  drivers/cpufreq/cpufreq_governor.c     | 106 +++++++++++++++++++++++++++++++--
>  drivers/cpufreq/cpufreq_governor.h     |   2 +
>  drivers/cpufreq/cpufreq_ondemand.c     |  62 +++++++++++++++----
>  4 files changed, 193 insertions(+), 23 deletions(-)

Applied to the linux-next branch of the linux-pm.git tree as v3.9 material.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
