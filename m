Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbaJ2NZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:25:58 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:55101 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595AbaJ2NZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <1414066336-11168-2-git-send-email-geert+renesas@glider.be>
References: <1414066336-11168-1-git-send-email-geert+renesas@glider.be>
	<1414066336-11168-2-git-send-email-geert+renesas@glider.be>
Date: Wed, 29 Oct 2014 14:25:51 +0100
Message-ID: <CAPDyKFr+8A_i5GyrL+KOv7AvqoMEFaiJ0ck9AQGn=M4vJ7g7Xg@mail.gmail.com>
Subject: Re: [PATCH 2/2] PM / Domains: Extract code to power off/on a PM domain
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 October 2014 14:12, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> PM domains are powered on/off from various places. Some callers do
> latency measurements, others don't. Consolidate using two helper
> functions, which always measure the latencies, and update the stored
> latencies when needed.
>
> Other minor changes:
>   - Use pr_warn() instead of pr_warning(),
>   - There's no need to check genpd->name, %s handles NULL pointers fine,
>   - Make the warning format strings identical, to save memory.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Though, some minor thoughts below.

> ---
>  drivers/base/power/domain.c | 101 ++++++++++++++++++++++++++------------------
>  1 file changed, 60 insertions(+), 41 deletions(-)
>
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 28d6e8bf746c4683..7b2007be51188ff8 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -151,6 +151,59 @@ static void genpd_recalc_cpu_exit_latency(struct generic_pm_domain *genpd)
>         genpd->cpuidle_data->idle_state->exit_latency = usecs64;
>  }
>
> +static int do_genpd_power_on(struct generic_pm_domain *genpd)

Should we try to agree on the prefixes of the function names in genpd?
Currently there are a mix of them.

May I suggest we try to stick to this:

Exported functions:
pm_genpd_*
_pm_genpd_*
__pm_genpd_*

Static functions:
genpd_*
_genpd_*
__genpd_*

What do you think? Do you have any better suggestions?

Kind regards
Uffe
