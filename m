Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143Ab3B0OXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 09:23:45 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:58430 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab3B0OXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 09:23:44 -0500
Message-ID: <512E16EE.2050201@slimlogic.co.uk>
Date: Wed, 27 Feb 2013 14:23:42 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, ian@slimlogic.co.uk, lrg@ti.com
Subject: Re: [PATCH] regulator: palmas: use correct device node for DT parsing
References: <1361974224-18180-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1361974224-18180-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/13 14:10, Laxman Dewangan wrote:
> When device is registered through the DT then regulators node
> exist in the parent device node of regulator driver. Hence passing
> parent device node for parsing DT in place of self-device node
> which is typically NULL.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>  drivers/regulator/palmas-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index e915629..f07501d 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -591,7 +591,7 @@ static int palmas_probe(struct platform_device *pdev)
>  {
>  	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
>  	struct palmas_pmic_platform_data *pdata = pdev->dev.platform_data;
> -	struct device_node *node = pdev->dev.of_node;
> +	struct device_node *node = pdev->dev.parent->of_node;
>  	struct regulator_dev *rdev;
>  	struct regulator_config config = { };
>  	struct palmas_pmic *pmic;
This is not correct, nor is the reasoning.

I suspect your previous patch broke DT probing so your not getting nodes
filled in.

Graeme

