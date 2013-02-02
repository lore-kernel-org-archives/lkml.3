Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757634Ab3BBDXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 22:23:11 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:52065 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab3BBDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 22:22:57 -0500
MIME-Version: 1.0
In-Reply-To: <1359744343-18690-3-git-send-email-dirk.brandewie@gmail.com>
References: <1359744343-18690-1-git-send-email-dirk.brandewie@gmail.com>
	<1359744343-18690-3-git-send-email-dirk.brandewie@gmail.com>
Date: Sat, 2 Feb 2013 08:52:55 +0530
X-Google-Sender-Auth: MxctlyObTmjAi2gzLaE_hLgq2Jw
Message-ID: <CAOh2x=mb0ffYoS70L_63T1YUG6a74EazyxM0R3ec2GTN2PPWTQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] cpufreq: Only query drivers that implement cpufreq_driver.target()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 2, 2013 at 12:15 AM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Scaling drivers that implement cpufreq_driver.setpolicy() have
> internal governors and may/will change the current operating frequency
> very frequently this will cause cpufreq_out_of_sync() to be called
> every time. Only call cpufreq_driver.get() for drivers that implement
> cpufreq_driver.target()
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 1c037f0..493cd50 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1794,7 +1794,7 @@ int cpufreq_update_policy(unsigned int cpu)
>
>         /* BIOS might change freq behind our back
>           -> ask driver for current freq and notify governors about a change */
> -       if (cpufreq_driver->get) {
> +       if (cpufreq_driver->get && cpufreq_driver->target) {

This would mean policy->cur has a garbage value. I don't really know
how would other routine behave on this. Would it make sense to make
policy->cur zero atleast?
