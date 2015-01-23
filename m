Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbbAWGi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:38:27 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:57743 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbbAWGiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:38:23 -0500
MIME-Version: 1.0
In-Reply-To: <1421989367-32721-3-git-send-email-jaewon02.kim@samsung.com>
References: <1421989367-32721-1-git-send-email-jaewon02.kim@samsung.com>
	<1421989367-32721-3-git-send-email-jaewon02.kim@samsung.com>
Date: Fri, 23 Jan 2015 07:38:22 +0100
Message-ID: <CAJKOXPdoDZH1CmNOkZuw_Bx9pT_drP0ZrSLB8jmJpDR+sacRjg@mail.gmail.com>
Subject: Re: [PATCH 2/6] extcon: max77843: Add max77843 MUIC driver
From: =?UTF-8?Q?Krzysztof_Koz=C5=82owski?= <k.kozlowski.k@gmail.com>
To: Jaewon Kim <jaewon02.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pm@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sebastian Reichel <sre@kernel.org>, Mark Brown <broonie@kernel.org>,
        Beomho Seo <beomho.seo@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-23 6:02 GMT+01:00 Jaewon Kim <jaewon02.kim@samsung.com>:
> This patch adds MAX77843 extcon driver to support for MUIC(Micro
> USB Interface Controller) device by using EXTCON subsystem to handle
> various external connectors.
>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
> ---
>  drivers/extcon/Kconfig           |   10 +
>  drivers/extcon/Makefile          |    1 +
>  drivers/extcon/extcon-max77843.c |  871 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 882 insertions(+)
>  create mode 100644 drivers/extcon/extcon-max77843.c
>

(...)

> +static int max77843_muic_remove(struct platform_device *pdev)
> +{
> +       struct max77843_muic_info *info = platform_get_drvdata(pdev);
> +
> +       cancel_work_sync(&info->irq_work);
> +

Missing regmap_del_irq_chip().

Best regards,
Krzysztof
