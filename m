Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab3I3Kwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:52:43 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40884 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab3I3Kwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:52:41 -0400
MIME-Version: 1.0
In-Reply-To: <1380010102-25817-2-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
	<1380010102-25817-2-git-send-email-l.majewski@samsung.com>
Date: Mon, 30 Sep 2013 16:22:40 +0530
X-Google-Sender-Auth: xnbJawIv47-jZjr6vep9rWO-Ii4
Message-ID: <CADGdYn4+R_YmzXtDH2sv0qFXbtE-gYcGO8uBe7mk78=_HXLQeg@mail.gmail.com>
Subject: Re: [PATCH 1/6] thermal: exynos: fix: Return from exynos_report_trigger()
 when therm_dev is NULL
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 1:38 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> The commit 4de0bdaa9677d11406c9becb70c60887c957e1f0
> ("thermal: exynos: Add support for instance based register/unregister")
> broke check for presence of therm_dev at global thermal zone in
> exynos_report_trigger().
>
> The resulting wrong test prevents thermal_zone_device_update() call, which
> calls handlers for situation when trip points are passed.
> Such behavior prevents thermal driver from proper reaction (when TMU interrupt
> is raised) in a situation when overheating is detected at TMU hardware.
> This patch fixes it.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
> index f10a6ad..55a912a 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -310,7 +310,7 @@ void exynos_report_trigger(struct thermal_sensor_conf *conf)
>         }
>
>         th_zone = conf->pzone_data;
> -       if (th_zone->therm_dev)
> +       if (!th_zone->therm_dev)
>                 return;
Changes looks fine.
Reviewed-by: Amit Daniel Kachhap<amit.daniel@samsung.com>

Thanks,
Amit Daniel
>
>         if (th_zone->bind == false) {
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

On Tue, Sep 24, 2013 at 1:38 PM, Lukasz Majewski <l.majewski@samsung.com> wrote:
> The commit 4de0bdaa9677d11406c9becb70c60887c957e1f0
> ("thermal: exynos: Add support for instance based register/unregister")
> broke check for presence of therm_dev at global thermal zone in
> exynos_report_trigger().
>
> The resulting wrong test prevents thermal_zone_device_update() call, which
> calls handlers for situation when trip points are passed.
> Such behavior prevents thermal driver from proper reaction (when TMU interrupt
> is raised) in a situation when overheating is detected at TMU hardware.
> This patch fixes it.
>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
> index f10a6ad..55a912a 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.c
> +++ b/drivers/thermal/samsung/exynos_thermal_common.c
> @@ -310,7 +310,7 @@ void exynos_report_trigger(struct thermal_sensor_conf *conf)
>         }
>
>         th_zone = conf->pzone_data;
> -       if (th_zone->therm_dev)
> +       if (!th_zone->therm_dev)
>                 return;
>
>         if (th_zone->bind == false) {
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
