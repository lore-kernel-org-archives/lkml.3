Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaG1GrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:47:17 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52936 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbaG1GrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:47:16 -0400
Date: Mon, 28 Jul 2014 07:47:10 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: arizona: Map MICVDD from extcon device to the
 Arizona core
Message-ID: <20140728064710.GB3973@lee--X1>
References: <1406301884-7145-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1406301884-7145-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406301884-7145-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014, Charles Keepax wrote:

> The extcon driver should be able to get its regulator against rather
> than against the main arizona device, we must add a supply mapping
> allowing the regulator to be located. This patch does so.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-core.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
> index e0d415e..cf3689f 100644
> --- a/drivers/mfd/arizona-core.c
> +++ b/drivers/mfd/arizona-core.c
> @@ -578,17 +578,21 @@ static const struct mfd_cell early_devs[] = {
>  };
>  
>  static const char *wm5102_supplies[] = {
> +	"MICVDD",
>  	"DBVDD2",
>  	"DBVDD3",
>  	"CPVDD",
>  	"SPKVDDL",
>  	"SPKVDDR",
> -	"MICVDD",
>  };
>  
>  static const struct mfd_cell wm5102_devs[] = {
>  	{ .name = "arizona-micsupp" },
> -	{ .name = "arizona-extcon" },
> +	{
> +		.name = "arizona-extcon",
> +		.parent_supplies = wm5102_supplies,
> +		.num_parent_supplies = 1, /* We only need MICVDD */
> +	},
>  	{ .name = "arizona-gpio" },
>  	{ .name = "arizona-haptics" },
>  	{ .name = "arizona-pwm" },
> @@ -601,7 +605,11 @@ static const struct mfd_cell wm5102_devs[] = {
>  
>  static const struct mfd_cell wm5110_devs[] = {
>  	{ .name = "arizona-micsupp" },
> -	{ .name = "arizona-extcon" },
> +	{
> +		.name = "arizona-extcon",
> +		.parent_supplies = wm5102_supplies,
> +		.num_parent_supplies = 1, /* We only need MICVDD */
> +	},
>  	{ .name = "arizona-gpio" },
>  	{ .name = "arizona-haptics" },
>  	{ .name = "arizona-pwm" },
> @@ -621,7 +629,11 @@ static const char *wm8997_supplies[] = {
>  
>  static const struct mfd_cell wm8997_devs[] = {
>  	{ .name = "arizona-micsupp" },
> -	{ .name = "arizona-extcon" },
> +	{
> +		.name = "arizona-extcon",
> +		.parent_supplies = wm8997_supplies,
> +		.num_parent_supplies = 1, /* We only need MICVDD */
> +	},
>  	{ .name = "arizona-gpio" },
>  	{ .name = "arizona-haptics" },
>  	{ .name = "arizona-pwm" },

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
