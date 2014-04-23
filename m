Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaDWMjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:39:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:53873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbaDWMjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:39:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 3/8] ARM: sunxi: Move the clock protection to machine hooks
Date: Wed, 23 Apr 2014 14:39:02 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, devicetree@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>, andriy.shevchenko@intel.com,
        linux-kernel@vger.kernel.org, zhuzhenhua@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        dmaengine@vger.kernel.org
References: <1397724379-15398-1-git-send-email-maxime.ripard@free-electrons.com> <1397724379-15398-4-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1397724379-15398-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231439.02913.arnd@arndb.de>
X-Provags-ID: V02:K0:g0D1Jlh43TPJyzCrWy+fulpEA2pwRozLlpJ0HH2xJ70
 ju+E5gqte7QSLEK2m+IIryHIUgFcO05CJvGZZzBIbAjm2Gjipb
 ROg9rKo++8LKMNMIFMCykjUu+ZF2AlBpu0ZJP+nuq9u7ZH8Ihu
 p9C6psf+BY0R51ipuRbm1Mvk2hGzxDOFVTZ2jBW4gGwHTL90Uo
 uwg6ezHNcLOsQM65S7kQdNencluQ/8Ht2xS5LKFOgGPkPm997V
 b1q11QrnTt3CIfvBXlkHT6BuwJWjmHY0VPYFJ/1NdGFfesQtKK
 g9v00BizDnnus6hw8NXu5c04Jfvx7GpfQ3pNAZ7l+aqmfHB/BG
 NEzQih2ekpcYqCkIv/Uk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014, Maxime Ripard wrote:
> Since we start to have a lot of clocks to protect, some of them in a few boards
> only, it becomes difficult to handle the clock protection without having to add
> per machine exceptions.
> 
> Move these where they belong, in the machine definition code.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

I don't like the fact that these are required to be hardcoded
anywhere in source code.

> +#include <linux/clk.h>
>  #include <linux/init.h>
>  #include <linux/of_platform.h>
>  
> @@ -19,9 +20,17 @@
>  
>  static void __init sun4i_dt_init(void)
>  {
> +       struct clk *clk;
> +
>         sunxi_setup_restart();
>  
>         of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
> +
> +       /* Make sure the clocks we absolutely need are enabled */
> +       /* DDR clock */
> +       clk = clk_get(NULL, "pll5_ddr");
> +       if (!IS_ERR(clk))
> +               clk_prepare_enable(clk);
>  }

Isn't there already DT syntax to do the same? If not, should there be?

	Arnd
