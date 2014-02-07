Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbaBGBgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 20:36:45 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61203 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBGBgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 20:36:41 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F438A9.9000908@roeck-us.net>
Date: Thu, 06 Feb 2014 17:36:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Chew <achew@nvidia.com>, wim@iguana.be, rob@landley.net,
        swarren@wwwdotorg.org, thierry.reding@gmail.com,
        grant.likely@linaro.org, robh+dt@kernel.org, abrestic@chromium.org,
        dgreid@chromium.org, katierh@chromium.org
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 1/1] watchdog: Add tegra watchdog
References: <1391724356-17034-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1391724356-17034-1-git-send-email-achew@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 02:05 PM, Andrew Chew wrote:
> Add a driver for the hardware watchdogs in NVIDIA Tegra SoCs (Tegra30 and
> later).  This driver will configure one watchdog timer that will reset the
> system in the case of a watchdog timeout.
>
> This driver binds to the nvidia,tegra30-timer device node and gets its
> register base from there.
>
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---

Hi Andrew,

> +
> +	/* This is the timer base. */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		dev_err(&pdev->dev, "incorrect resources\n");
> +		return -ENODEV;
> +	}
> +

I thought I mentioned that before - dem_iomap_resource() creates the
very same error message and returns an error if NULL is passed
as res argument to it. So the above error message (and error check)
is really redundant.

Thanks,
Guenter

