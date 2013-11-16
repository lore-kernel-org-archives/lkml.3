Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3KPA7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:59:46 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:54696 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3KPA7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:59:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, santosh.shilimkar@ti.com
Subject: Re: [PATCH] cpufreq: OMAP: Fix compilation error 'r & ret undeclared'
Date: Sat, 16 Nov 2013 02:12:10 +0100
Message-ID: <5914011.HGqL7cXjSj@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <c5d802f9efd94a2fafea738d370feff85272bf9a.1384337302.git.viresh.kumar@linaro.org>
References: <c5d802f9efd94a2fafea738d370feff85272bf9a.1384337302.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 13, 2013 03:39:23 PM Viresh Kumar wrote:
> With a recent change "d4019f0 cpufreq: move freq change notifications to cpufreq
> core" few variables (r & ret) are removed by mistake and hence these warnings:
> 
> drivers/cpufreq/omap-cpufreq.c: In function omap_target:
> drivers/cpufreq/omap-cpufreq.c:64:2: error: ret undeclared (first use in this function)
> drivers/cpufreq/omap-cpufreq.c:64:2: note: each undeclared identifier is reported only once for each function it appears in
> drivers/cpufreq/omap-cpufreq.c:94:3: error: r undeclared (first use in this function)
> drivers/cpufreq/omap-cpufreq.c:116:1: warning: control reaches end of non-void function [-Wreturn-type]
> 
> Lets fix them by declaring those variables again.
> 
> Reported-by: Sebastian Capella <sebastian.capella@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Queued up for the next PM pull request, thanks!

> ---
>  drivers/cpufreq/omap-cpufreq.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
> index be6d143..a0acd0b 100644
> --- a/drivers/cpufreq/omap-cpufreq.c
> +++ b/drivers/cpufreq/omap-cpufreq.c
> @@ -53,6 +53,7 @@ static unsigned int omap_getspeed(unsigned int cpu)
>  
>  static int omap_target(struct cpufreq_policy *policy, unsigned int index)
>  {
> +	int r, ret;
>  	struct dev_pm_opp *opp;
>  	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
>  	unsigned int old_freq, new_freq;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
