Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582Ab3BYLMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 06:12:31 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:35400 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab3BYLM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 06:12:29 -0500
MIME-Version: 1.0
In-Reply-To: <1361790465-21760-1-git-send-email-emilio@elopez.com.ar>
References: <1361725277-5125-1-git-send-email-emilio@elopez.com.ar>
	<1361790465-21760-1-git-send-email-emilio@elopez.com.ar>
Date: Mon, 25 Feb 2013 16:42:27 +0530
X-Google-Sender-Auth: YVG9zME04hsEPholc9Q08LPz0qg
Message-ID: <CAOh2x=nZ9hsTx+kay0Le-qVJLeh3vTY2eUHW7hHdVQV_eXc4yw@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: highbank: do not initialize array with a loop
From: Viresh Kumar <viresh.kumar@linaro.org>
To: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>
Cc: rjw@sisk.pl, shawn.guo@linaro.org, mark.langsdorf@calxeda.com,
        linux-arm-kernel@lists.infradead.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 4:37 PM, Emilio López <emilio@elopez.com.ar> wrote:
> As uninitialized array members will be initialized to zero, we can
> avoid using a for loop by setting a value to it.
>
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> ---
>
> Note that I don't own any device using this driver, it has only been compile
> tested, but it shouldn't cause any issues.
>
> Changes v1 -> v2:
>   * Move freq / 1000000 to the array definition as suggested by Viresh Kumar
>
>  drivers/cpufreq/highbank-cpufreq.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> index 66e3a71..b61b5a3 100644
> --- a/drivers/cpufreq/highbank-cpufreq.c
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -28,13 +28,7 @@
>
>  static int hb_voltage_change(unsigned int freq)
>  {
> -       int i;
> -       u32 msg[HB_CPUFREQ_IPC_LEN];
> -
> -       msg[0] = HB_CPUFREQ_CHANGE_NOTE;
> -       msg[1] = freq / 1000000;
> -       for (i = 2; i < HB_CPUFREQ_IPC_LEN; i++)
> -               msg[i] = 0;
> +       u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};

If you haven't crossed 80 width:

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

>
>         return pl320_ipc_transmit(msg);
>  }
