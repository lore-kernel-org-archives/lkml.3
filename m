Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756954Ab3BFBuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:50:37 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38483 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab3BFBud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:50:33 -0500
MIME-Version: 1.0
In-Reply-To: <1360088646-19104-5-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-5-git-send-email-dirk.brandewie@gmail.com>
Date: Wed, 6 Feb 2013 07:20:32 +0530
X-Google-Sender-Auth: lKfHKmzfVvYCQK3QGAg4itCr8LM
Message-ID: <CAOh2x==4Zi=-bLh3SBxjp0xpc6P3WV3wcctLnV3kQUhjuGhPqw@mail.gmail.com>
Subject: Re: [PATCH 4/7] cpufreq: Do not track governor name for scaling
 drivers with internal governors.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 11:54 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Scaling drivers that implement internal governors do not have governor
> structures assocaited with them.  Only track the name of the governor
> associated with the CPU if the driver does not implement
> cpufreq_driver.setpolicy()
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index d8daa4b..622e282 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1050,7 +1050,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>                 __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>
>  #ifdef CONFIG_HOTPLUG_CPU
> -       strncpy(per_cpu(cpufreq_cpu_governor, cpu), data->governor->name,
> +       if (!cpufreq_driver->setpolicy)
> +               strncpy(per_cpu(cpufreq_cpu_governor, cpu),
> +                       data->governor->name,
>                         CPUFREQ_NAME_LEN);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
