Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab3BGKno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:43:44 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34821 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab3BGKnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:43:40 -0500
MIME-Version: 1.0
In-Reply-To: <1360170133-5066-5-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
	<1360170133-5066-5-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 7 Feb 2013 16:13:38 +0530
X-Google-Sender-Auth: 4OFP5oEMz45xVrUHKnUxZgMOPrA
Message-ID: <CAOh2x=m4dXaVJxLYnz_Kxc91VZwiwFyB9ounXK69Qd_Hn7LNDQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] cpufreq: Do not track governor name for scaling
 drivers with internal governors.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:32 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Scaling drivers that implement internal governors do not have governor
> structures assocaited with them.  Only track the name of the governor
> associated with the CPU if the driver does not implement
> cpufreq_driver.setpolicy()
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 0ba0344..e772053 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1049,7 +1049,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>                 __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>
>  #ifdef CONFIG_HOTPLUG_CPU
> -       strncpy(per_cpu(cpufreq_cpu_governor, cpu), data->governor->name,
> +       if (!cpufreq_driver->setpolicy)
> +               strncpy(per_cpu(cpufreq_cpu_governor, cpu),
> +                       data->governor->name,
>                         CPUFREQ_NAME_LEN);

While applying this patch in my repo, i have merged above two lines into a
single line.
