Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab3H3Lw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:52:27 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:44635 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3H3LwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:52:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Len Brown <lenb@kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / cpuidle: remove superfluous pr == NULL checks
Date: Fri, 30 Aug 2013 14:03:11 +0200
Message-ID: <4642597.rqCVoqqdF0@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0-rc7+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5858980.cRdNx0rNzu@amdc1032>
References: <5858980.cRdNx0rNzu@amdc1032>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 30, 2013 12:30:51 PM Bartlomiej Zolnierkiewicz wrote:
> The only acpi_processor_get_power_info_fadt() user
> (acpi_processor_get_power_info()) dereferences pr before calling
> the function.
> 
> The only acpi_processor_hotplug() user (acpi_cpu_soft_notify())
> checks for pr == NULL before calling the function.
> 
> The only acpi_processor_cst_has_changed() user (acpi_processor_notify())
> checks for pr == NULL before calling the function.
> 
> The only acpi_processor_power_init() user (__acpi_processor_start())
> dereferences pr before calling the function.
> 
> Thus remove superfluous pr == NULL checks from affected functions.
> 
> Also:
> 
> While at it remove redundant brackets from acpi_processor_hotplug().
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Len Brown <lenb@kernel.org>

Thanks, I'll queue this up for 3.13.


> ---
>  drivers/acpi/processor_idle.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
> index f98dd00..35c8f2b 100644
> --- a/drivers/acpi/processor_idle.c
> +++ b/drivers/acpi/processor_idle.c
> @@ -272,9 +272,6 @@ static void tsc_check_state(int state) { return; }
>  static int acpi_processor_get_power_info_fadt(struct acpi_processor *pr)
>  {
>  
> -	if (!pr)
> -		return -EINVAL;
> -
>  	if (!pr->pblk)
>  		return -ENODEV;
>  
> @@ -1076,12 +1073,8 @@ int acpi_processor_hotplug(struct acpi_processor *pr)
>  	if (disabled_by_idle_boot_param())
>  		return 0;
>  
> -	if (!pr)
> -		return -EINVAL;
> -
> -	if (nocst) {
> +	if (nocst)
>  		return -ENODEV;
> -	}
>  
>  	if (!pr->flags.power_setup_done)
>  		return -ENODEV;
> @@ -1108,9 +1101,6 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
>  	if (disabled_by_idle_boot_param())
>  		return 0;
>  
> -	if (!pr)
> -		return -EINVAL;
> -
>  	if (nocst)
>  		return -ENODEV;
>  
> @@ -1183,9 +1173,6 @@ int acpi_processor_power_init(struct acpi_processor *pr)
>  		first_run++;
>  	}
>  
> -	if (!pr)
> -		return -EINVAL;
> -
>  	if (acpi_gbl_FADT.cst_control && !nocst) {
>  		status =
>  		    acpi_os_write_port(acpi_gbl_FADT.smi_command, acpi_gbl_FADT.cst_control, 8);
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
