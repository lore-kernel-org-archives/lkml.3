Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab3BYDlW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:41:22 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:52752 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759505Ab3BYDlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:41:20 -0500
MIME-Version: 1.0
In-Reply-To: <1361725277-5125-1-git-send-email-emilio@elopez.com.ar>
References: <1361725277-5125-1-git-send-email-emilio@elopez.com.ar>
Date: Mon, 25 Feb 2013 09:11:18 +0530
X-Google-Sender-Auth: PAK8-lrnWGdSKlcqYjb_7V633wE
Message-ID: <CAOh2x=nDZpBaqjzO22k66Bb30mVEhAdy02EFDP9RDibA50Sx7A@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: highbank: do not initialize array with a loop
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
Cc: rjw@sisk.pl, shawn.guo@linaro.org, mark.langsdorf@calxeda.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 10:31 PM, Emilio López <emilio@elopez.com.ar> wrote:
> As uninitialized array members will be initialized to zero, we can
> avoid using a for loop by setting a value to it.
>
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> ---
> Note that I don't own any device using this driver, it has only been compile
> tested, but it shouldn't cause any issues.
>
>  drivers/cpufreq/highbank-cpufreq.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> index 66e3a71..30d4ae1 100644
> --- a/drivers/cpufreq/highbank-cpufreq.c
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -28,13 +28,9 @@
>
>  static int hb_voltage_change(unsigned int freq)
>  {
> -       int i;
> -       u32 msg[HB_CPUFREQ_IPC_LEN];
> +       u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE};
>
> -       msg[0] = HB_CPUFREQ_CHANGE_NOTE;
>         msg[1] = freq / 1000000;

I think this can also be part of the definition of array, isn't it?

So it would be something like:

u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};

> -       for (i = 2; i < HB_CPUFREQ_IPC_LEN; i++)
> -               msg[i] = 0;
>
>         return pl320_ipc_transmit(msg);
>  }
> --
> 1.8.2.rc0
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
