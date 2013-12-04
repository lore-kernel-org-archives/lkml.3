Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab3LDFSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 00:18:52 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12116 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LDFSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 00:18:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 03 Dec 2013 21:15:53 -0800
Message-ID: <529EBB29.2030008@nvidia.com>
Date: Wed, 4 Dec 2013 14:18:33 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: Re: [PATCHv4] ARM: tegra: add gpiod_lookup table for paz00
References: <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com> <1386074998-17833-1-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1386074998-17833-1-git-send-email-heikki.krogerus@linux.intel.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 09:49 PM, Heikki Krogerus wrote:
> This makes it possible to request the gpio descriptors in
> rfkill_gpio driver regardless of the platform.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> ---
>   arch/arm/mach-tegra/board-paz00.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
>
> Changes since v3:
> -----------------
> Rebased on top of Alexandre's patch "gpio: better lookup method for
> platform GPIOs".
>
> diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
> index 06f0240..e4dec9f 100644
> --- a/arch/arm/mach-tegra/board-paz00.c
> +++ b/arch/arm/mach-tegra/board-paz00.c
> @@ -18,6 +18,7 @@
>    */
>
>   #include <linux/platform_device.h>
> +#include <linux/gpio/driver.h>
>   #include <linux/rfkill-gpio.h>
>   #include "board.h"
>
> @@ -36,7 +37,17 @@ static struct platform_device wifi_rfkill_device = {
>   	},
>   };
>
> +static struct gpiod_lookup_table wifi_gpio_lookup = {
> +	.dev_id = "rfkill_gpio",
> +	.table = {
> +		GPIO_LOOKUP_IDX("tegra-gpio", 25, NULL, 0, 0),
> +		GPIO_LOOKUP_IDX("tegra-gpio", 85, NULL, 1, 0),

nit: the flags could be changed to GPIO_ACTIVE_HIGH (which evaluates to 
0) to be more explicit.
