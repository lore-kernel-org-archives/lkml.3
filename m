Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbaCNPWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:22:48 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53840 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbaCNPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:22:44 -0400
MIME-Version: 1.0
In-Reply-To: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
References: <20140314140542.f4ded6c50dbd8a1d937bf354@samsung.com>
Date: Fri, 14 Mar 2014 20:52:43 +0530
Message-ID: <CAK9yfHw7zYaX9EYFE+m3Mh-u8Uiyubx-cS0EwPmfW+0weLiBKw@mail.gmail.com>
Subject: Re: [PATCH v11 10/27] iommu/exynos: use managed device helper functions
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 14 March 2014 10:35, Cho KyongHo <pullip.cho@samsung.com> wrote:
> This patch uses managed device helper functions in the probe().
>
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
[snip]

> +       data->clk = devm_clk_get(dev, "sysmmu");
> +       if (IS_ERR(data->clk)) {
> +               dev_info(dev, "No gate clock found!\n");
> +               data->clk = NULL;
> +       }

Why aren't you returning from here upon error?

> +
> +       ret = clk_prepare(data->clk);
> +       if (ret) {
> +               dev_err(dev, "Failed to prepare clk\n");
> +               return ret;
>         }
>
>         data->sysmmu = dev;
> @@ -556,17 +553,8 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
>
>         pm_runtime_enable(dev);
>
> -       dev_dbg(dev, "Initialized\n");
> +       dev_dbg(dev, "Probed and initialized\n");

This message looks redundant.

-- 
With warm regards,
Sachin
