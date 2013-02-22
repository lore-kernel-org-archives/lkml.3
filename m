Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3BVKma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:42:30 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7678 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3BVKm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:42:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 22 Feb 2013 02:37:34 -0800
Message-ID: <51274B5C.4080601@nvidia.com>
Date: Fri, 22 Feb 2013 16:11:32 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Ian Lartey <ian@slimlogic.co.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/2] regulator: palmas fix SMPS no voltages
References: <1361494325-4416-1-git-send-email-ian@slimlogic.co.uk>
In-Reply-To: <1361494325-4416-1-git-send-email-ian@slimlogic.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2013 06:22 AM, Ian Lartey wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
>
> Number of voltages for SMPS regulators was off by one.
>
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> ---
>   drivers/regulator/palmas-regulator.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index cde13bb..39cf146 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -4,6 +4,7 @@
>    * Copyright 2011-2012 Texas Instruments Inc.
>    *
>    * Author: Graeme Gregory <gg@slimlogic.co.uk>
> + * Author: Ian Lartey <ian@slimlogic.co.uk>
>    *
>    *  This program is free software; you can redistribute it and/or modify it
>    *  under  the terms of the GNU General  Public License as published by the
> @@ -156,7 +157,7 @@ static const struct regs_info palmas_regs_info[] = {
>    *
>    * So they are basically (maxV-minV)/stepV
>    */
> -#define PALMAS_SMPS_NUM_VOLTAGES	116
> +#define PALMAS_SMPS_NUM_VOLTAGES	117

Yes, if we keep one for  0.5V and one for 1.65 the it becomes 117 
including off.

Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
