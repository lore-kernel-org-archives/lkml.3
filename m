Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374AbaACGuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 01:50:09 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:45478 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaACGuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 01:50:06 -0500
MIME-Version: 1.0
In-Reply-To: <1388731451-10963-1-git-send-email-jiel@marvell.com>
References: <1388731451-10963-1-git-send-email-jiel@marvell.com>
Date: Fri, 3 Jan 2014 12:20:05 +0530
Message-ID: <CAKohpomWCpxCSFfG601Pc_FKcbZ3J7G2nsBABMb8qqQJ38h1cg@mail.gmail.com>
Subject: Re: [PATCH v3] cpufreq: Fix timer/workqueue corruption by protecting
 reading governor_enabled
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jane Li <jiel@marvell.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 January 2014 12:14,  <jiel@marvell.com> wrote:
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index dc196bb..15c62df 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -389,6 +389,7 @@ int __cpufreq_driver_target(struct cpufreq_policy *policy,
>                                    unsigned int relation);
>  int cpufreq_register_governor(struct cpufreq_governor *governor);
>  void cpufreq_unregister_governor(struct cpufreq_governor *governor);
> +extern struct mutex cpufreq_governor_lock;
>
>  /* CPUFREQ DEFAULT GOVERNOR */
>  /*

Move this to cpufreq_governor.h instead. I don't want this to be available
for everybody to use it.
