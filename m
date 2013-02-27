Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab3B0Apk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:45:40 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:35526 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009Ab3B0Apf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:45:35 -0500
MIME-Version: 1.0
In-Reply-To: <1361515707-8571-1-git-send-email-tushar.behera@linaro.org>
References: <51271673.9090003@linaro.org>
	<1361515707-8571-1-git-send-email-tushar.behera@linaro.org>
Date: Wed, 27 Feb 2013 09:45:34 +0900
X-Google-Sender-Auth: K37HvzzftSiIJKq1eHI_d1RYAe8
Message-ID: <CAH9JG2XpSCGArKGPwzZK_YPsP4VMQTS6u+DJFkuappc5TY4g-Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Keep USB related LDOs always active on Origen
From: Kyungmin Park <kmpark@infradead.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, john.stultz@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 22, 2013 at 3:48 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
> LDO3 and LDO8 are used for powering both device and host phy controllers.
> These regulators are not handled in USB host driver. Hence we get
> unexpected behaviour when the regulators are disabled elsewhere.
>
> It would be best to keep these regulators always on.
No, it's just workaround patch.

It should be handled at USB drivers.
we usually used this scheme enable USB power always. but it consumes
lots of power.
There's no need to enable usb power when there's no usb connection.

So I suggest to enable power when usb is connected only.

In our case, micro IC detects the usb connection and enable usb power
at that time.

Thank you,
Kyungmin Park
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>
> Based on v3.8.
>
>  arch/arm/mach-exynos/mach-origen.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
> index 5e34b9c..7351063 100644
> --- a/arch/arm/mach-exynos/mach-origen.c
> +++ b/arch/arm/mach-exynos/mach-origen.c
> @@ -169,6 +169,7 @@ static struct regulator_init_data __initdata max8997_ldo3_data = {
>                 .min_uV         = 1100000,
>                 .max_uV         = 1100000,
>                 .apply_uV       = 1,
> +               .always_on      = 1,
>                 .valid_ops_mask = REGULATOR_CHANGE_STATUS,
>                 .state_mem      = {
>                         .disabled       = 1,
> @@ -227,6 +228,7 @@ static struct regulator_init_data __initdata max8997_ldo8_data = {
>                 .min_uV         = 3300000,
>                 .max_uV         = 3300000,
>                 .apply_uV       = 1,
> +               .always_on      = 1,
>                 .valid_ops_mask = REGULATOR_CHANGE_STATUS,
>                 .state_mem      = {
>                         .disabled       = 1,
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
