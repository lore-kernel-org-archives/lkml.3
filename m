Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3BFCER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:04:17 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61898 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab3BFCEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:04:15 -0500
MIME-Version: 1.0
In-Reply-To: <1360088646-19104-6-git-send-email-dirk.brandewie@gmail.com>
References: <1360088646-19104-1-git-send-email-dirk.brandewie@gmail.com>
	<1360088646-19104-6-git-send-email-dirk.brandewie@gmail.com>
Date: Wed, 6 Feb 2013 07:28:26 +0530
X-Google-Sender-Auth: ZeFeDhfAQfi8mia06pdlJy_Nk_A
Message-ID: <CAOh2x=kJPFyhkG3y_q=a5ciG1HRAn-JkoVYy9OZ9POA+-isbCQ@mail.gmail.com>
Subject: Re: [PATCH 5/7] cpufreq: balance out cpufreq_cpu_{get,put} for
 scaling drivers using setpolicy
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
> There is an additional reference added to the driver in
> cpufreq_add_dev()  that is removed in__cpufreq_governor() if the
> driver implements target().  Remove the last reference when the
> driver implements setpolicy()
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 622e282..d17477b 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1049,6 +1049,9 @@ static int __cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif
>         if (cpufreq_driver->target)
>                 __cpufreq_governor(data, CPUFREQ_GOV_STOP);
>
> +       if (cpufreq_driver->setpolicy)
> +               cpufreq_cpu_put(data);

I don't understand this patch at all.. I grepped both cpufreq_cpu_get() & put()
in bleeding-edge and found everything to be correct.

Can you please point me to the exact line numbers ?
