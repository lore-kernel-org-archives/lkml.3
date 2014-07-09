Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbaGIDyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 23:54:24 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54515 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaGIDyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 23:54:22 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53BCBCEC.7010306@roeck-us.net>
Date: Tue, 08 Jul 2014 20:54:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Feng Kan <fkan@apm.com>, dbaryshkov@gmail.com, catalin.marinas@arm.com,
        dwmw2@infradead.org, arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com
Subject: Re: [PATCH V8 1/6] power: reset: Add generic SYSCON register mapped
 reset
References: <1404872153-3594-1-git-send-email-fkan@apm.com> <1404872153-3594-2-git-send-email-fkan@apm.com>
In-Reply-To: <1404872153-3594-2-git-send-email-fkan@apm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 07:15 PM, Feng Kan wrote:
> Add a generic SYSCON register mapped reset mechanism.
>
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>   drivers/power/reset/Kconfig         |  6 +++
>   drivers/power/reset/Makefile        |  1 +
>   drivers/power/reset/syscon-reboot.c | 91 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 98 insertions(+)
>   create mode 100644 drivers/power/reset/syscon-reboot.c
>
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index bdcf517..5877b38 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -80,3 +80,9 @@ config POWER_RESET_KEYSTONE
>   	help
>   	  Reboot support for the KEYSTONE SoCs.
>
> +config POWER_RESET_SYSCON
> +	bool "Generic SYSCON regmap reset driver"
> +	depends on ARM || ARM64 || COMPILE_TEST

As written, this driver is really not generic but very arm specific.
I don't think COMPILE_TEST is a good idea either, since arm_pm_restart
is only defined for the arm architecture. Did you try compiling allmodconfig
or allyesconfig for, say, x86_64 with this patch applied ?

I think this might benefit from using [1], which would make it really
generic.

Guenter

[1] http://www.spinics.net/lists/kernel/msg1780939.html

