Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3IVKOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:14:24 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:48771 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab3IVKOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:14:22 -0400
Message-ID: <523EDF16.10102@gmail.com>
Date: Sun, 22 Sep 2013 14:14:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Matt Porter <matt.porter@linaro.org>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <csd@broadcom.com>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        linux-tegra@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kernel@stlinux.com,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/26] ARM: provide common arch init for DT clocks
References: <20130920191613.GA25191@ohporter.com>
In-Reply-To: <20130920191613.GA25191@ohporter.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 09:16 PM, Matt Porter wrote:
> On Wed, Sep 18, 2013 at 07:53:33PM +0200, Sebastian Hesselbarth wrote:
>> This is a patch set based on an RFC [1][2] sent earlier to provide a common
>> arch/arm init for DT clock providers. Currently, the call to of_clk_init(NULL)
>> to initialize DT clock providers is spread among several mach-dirs. Since most
>> machs require DT clocks initialized before timers, no initcall can be used.
[...]
> Could you pick up the following patch for mach-bcm/ into this series?
>
> Thanks,
> Matt
>
>  From f65d048b3453447bb3e693cb21701c4d0c6375ed Mon Sep 17 00:00:00 2001
> From: Matt Porter <matt.porter@linaro.org>
> Date: Fri, 20 Sep 2013 13:41:06 -0400
> Subject: [PATCH] ARM: bcm: Remove custom .time_init hook
>
> With arch/arm calling of_clk_init(NULL) and clocksource_of_init()
> this is no longer needed. The former is useful because we can make
> use of dummy fixed clocks for drivers until the bcm281xx common
> clock driver is ready.
>
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Christian Daudt <csd@broadcom.com>

As a v2 is required due to calling of_clk_init() breaks non-DT builds,
I will include this _if_ Christian actually gives his Acked-By.

Sebastian

> ---
>   arch/arm/mach-bcm/board_bcm281xx.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-bcm/board_bcm281xx.c b/arch/arm/mach-bcm/board_bcm281xx.c
> index 8d9f931..26b2390 100644
> --- a/arch/arm/mach-bcm/board_bcm281xx.c
> +++ b/arch/arm/mach-bcm/board_bcm281xx.c
> @@ -68,7 +68,6 @@ static void __init board_init(void)
>   static const char * const bcm11351_dt_compat[] = { "brcm,bcm11351", NULL, };
>
>   DT_MACHINE_START(BCM11351_DT, "Broadcom Application Processor")
> -	.init_time = clocksource_of_init,
>   	.init_machine = board_init,
>   	.restart = bcm_kona_restart,
>   	.dt_compat = bcm11351_dt_compat,
>

