Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbaFJFVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:21:51 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:54242 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbaFJFVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <53962059.6070306@semaphore.gr>
References: <53962059.6070306@semaphore.gr>
Date: Tue, 10 Jun 2014 10:51:49 +0530
Message-ID: <CAKohpokABMSRr88Tf=+Kn4b4=r7ThE+mjdAZcU+dvo28b47Kcg@mail.gmail.com>
Subject: Re: [PATCH 1/7] cpufreq: intel_pstate: Remove duplicate CPU ID check
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Stratos Karafotis <stratosk@semaphore.gr>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2014 02:30, Stratos Karafotis <stratosk@semaphore.gr> wrote:
> We check the CPU ID during driver init. There is no need
> to do it again per logical CPU initialization.
>
> So, remove the duplicate check.
>
> Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> ---
>  drivers/cpufreq/intel_pstate.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> index aebd457..4e7f492 100644
> --- a/drivers/cpufreq/intel_pstate.c
> +++ b/drivers/cpufreq/intel_pstate.c
> @@ -691,14 +691,8 @@ MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
>
>  static int intel_pstate_init_cpu(unsigned int cpunum)
>  {
> -
> -       const struct x86_cpu_id *id;
>         struct cpudata *cpu;
>
> -       id = x86_match_cpu(intel_pstate_cpu_ids);
> -       if (!id)
> -               return -ENODEV;
> -
>         all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
>         if (!all_cpu_data[cpunum])
>                 return -ENOMEM;

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
