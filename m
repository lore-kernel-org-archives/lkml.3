Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3KPO5V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 09:57:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59920 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752642Ab3KPO5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 09:57:11 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: viresh.kumar@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Update PATCH 1/1] Cpufreq: Make governor data on nonboot cpus across system suspend/resume
Date: Sat, 16 Nov 2013 16:09:44 +0100
Message-ID: <2541765.pYv7UXDJWx@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <9847309.KdKOG5y1Zx@vostro.rjw.lan>
References: <1384495294-10565-1-git-send-email-tianyu.lan@intel.com> <5286EDBF.9050001@intel.com> <9847309.KdKOG5y1Zx@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 16, 2013 03:41:10 PM Rafael J. Wysocki wrote:

[...]

> > >> @@ -1822,6 +1822,9 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
> > >>   			((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
> > >>   		module_put(policy->governor->owner);
> > >>
> > >> +	if ((event == CPUFREQ_GOV_POLICY_INIT) && ret == -EALREADY)
> > >> +		ret = 0;
> > >> +
> 
> -> I'd prefer this check to be combined with the one done to determine whether
> or not we need to do the module_put().  Something like
> 
> 	if (event == CPUFREQ_GOV_POLICY_EXIT && ret) {

Obviously, that should be:

	if (event == CPUFREQ_GOV_POLICY_INIT && ret) {

> 		module_put(policy->governor->owner);
> 		if (ret == -EALREADY)
> 			return 0;
> 	} else if (event == CPUFREQ_GOV_POLICY_EXIT && !ret) {
> 		module_put(policy->governor->owner);
> 	}

Sorry for the confusion.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
