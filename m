Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3L0JkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 04:40:08 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:60875 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3L0JkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:40:06 -0500
MIME-Version: 1.0
In-Reply-To: <1388136651-21883-1-git-send-email-jiel@marvell.com>
References: <1388136651-21883-1-git-send-email-jiel@marvell.com>
Date: Fri, 27 Dec 2013 15:10:04 +0530
Message-ID: <CAKohpokWMgXotgKWFmqOPzdoZME=frBQOjeU1uFJwQ778DHAKg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Fix timer/workqueue corruption by protecting
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

On 27 December 2013 15:00,  <jiel@marvell.com> wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> -static DEFINE_MUTEX(cpufreq_governor_lock);

> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index dc196bb..4faafe7 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -254,6 +254,7 @@ struct cpufreq_driver {
>
>  int cpufreq_register_driver(struct cpufreq_driver *driver_data);
>  int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
> +static DEFINE_MUTEX(cpufreq_governor_lock);

No way, this would never work. This would create separate locks
in each file that includes cpufreq.h. And so the locks you are talking
about wouldn't protect governor.

Have you actually tested this code? If this fixes the breakage you
saw? If this fixes it then you need to do better investigation of your
problem..

you actually need to remove the static keyword from cpufreq.c file.
Nothing else.
