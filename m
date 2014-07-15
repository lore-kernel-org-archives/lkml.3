Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbaGODDB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:03:01 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:34822 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007AbaGODC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:02:58 -0400
MIME-Version: 1.0
In-Reply-To: <53C3F88A.8080005@samsung.com>
References: <1405080036-6651-1-git-send-email-tushar.b@samsung.com>
	<1405080036-6651-4-git-send-email-tushar.b@samsung.com>
	<53C3F88A.8080005@samsung.com>
Date: Tue, 15 Jul 2014 08:32:57 +0530
X-Google-Sender-Auth: lnVv2U4KuvH2GlkgmYnu8b5LR74
Message-ID: <CAC5m3Bwq5cGkN+kk+vWFdj6qjGJUCS3BduwhHMyVAQ6Mdbmh2A@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] clk: exynos-audss: Use samsung clock APIs to
 register/unregister clocks
From: Tushar Behera <tushar.b@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: ML Arch-Arm <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 9:04 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> On 11/07/14 14:00, Tushar Behera wrote:
>> @@ -103,17 +140,11 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
>>               return PTR_ERR(reg_base);
>>       }
>>
>> -     clk_table = devm_kzalloc(&pdev->dev,
>> -                             sizeof(struct clk *) * EXYNOS_AUDSS_MAX_CLKS,
>> -                             GFP_KERNEL);
>> -     if (!clk_table)
>> +     ctx = samsung_clk_init(pdev->dev.of_node, reg_base, nr_clks);
>
> There is an issue here that this registers the clk provider before all
> its clocks are registered with the clk core. Therefore it introduces
> a race condition.
>
> Please have a look at patch [1], you may want to rebase this series
> onto that patch.
>

Thanks for the pointer. I will re-post.

>> +     samsung_clk_register_div(ctx, exynos_audss_div_clks,
>> +                             ARRAY_SIZE(exynos_audss_div_clks));
> [...]
>> +     samsung_clk_register_gate(ctx, exynos_audss_gate_clks,
>> +                             ARRAY_SIZE(exynos_audss_gate_clks));
> [...]
>> -     ret = of_clk_add_provider(pdev->dev.of_node, of_clk_src_onecell_get,
>> -                                     &clk_data);
>> -     if (ret) {
>> -             dev_err(&pdev->dev, "failed to add clock provider\n");
>> -             goto unregister;
>> +             samsung_clk_register_gate(ctx, exynos5420_audss_gate_clks,
>> +                                     ARRAY_SIZE(exynos5420_audss_gate_clks));
>>       }
>
> [1]
> https://git.kernel.org/cgit/linux/kernel/git/tfiga/samsung-clk.git/commit/?h=samsung-clk-next&id=d5e136a21b2028fb1f45143ea7112d5869bfc6c7
>
> --
> Regards,
> Sylwester
