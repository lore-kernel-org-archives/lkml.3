Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252AbaJ2RGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:06:53 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:50175 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943AbaJ2RGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:06:51 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PM / Domains: Make genpd parameter of pm_genpd_present() const
References: <1414066336-11168-1-git-send-email-geert+renesas@glider.be>
Date: Wed, 29 Oct 2014 10:06:47 -0700
In-Reply-To: <1414066336-11168-1-git-send-email-geert+renesas@glider.be>
	(Geert Uytterhoeven's message of "Thu, 23 Oct 2014 14:12:15 +0200")
Message-ID: <7hzjceajq0.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert+renesas@glider.be> writes:

> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Kevin Hilman <khilman@linaro.org>

Though I tend to prefer a brief changlog that answers "why", even if it may seem obvious.

Kevin


> ---
>  drivers/base/power/domain.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 40bc2f4072cc28ea..28d6e8bf746c4683 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -753,9 +753,9 @@ static inline void genpd_power_off_work_fn(struct work_struct *work) {}
>   * pm_genpd_present - Check if the given PM domain has been initialized.
>   * @genpd: PM domain to check.
>   */
> -static bool pm_genpd_present(struct generic_pm_domain *genpd)
> +static bool pm_genpd_present(const struct generic_pm_domain *genpd)
>  {
> -	struct generic_pm_domain *gpd;
> +	const struct generic_pm_domain *gpd;
>  
>  	if (IS_ERR_OR_NULL(genpd))
>  		return false;
