Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3IXWMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:12:32 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:51775 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3IXWM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <524200FB.8010004@gmail.com>
References: <1379982078-23381-1-git-send-email-abrestic@chromium.org>
	<1380046016-5811-1-git-send-email-abrestic@chromium.org>
	<524200FB.8010004@gmail.com>
Date: Tue, 24 Sep 2013 15:12:27 -0700
X-Google-Sender-Auth: iPfpvl4TZEQwy_O6NfE1OLgZOdE
Message-ID: <CAL1qeaEpu=YRasZpSvrCTNwC6OGWZgECjwDSFgkAN07eWObmrg@mail.gmail.com>
Subject: Re: [PATCH V3 1/6] clk: exynos-audss: convert to platform device
From: Andrew Bresticker <abrestic@chromium.org>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Padmavathi Venna <padma.v@samsung.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static int exynos_audss_clk_remove(struct platform_device *pdev)
>> +{
>> +       int i;
>> +
>> +       of_clk_del_provider(pdev->dev.of_node);
>> +
>> +       for (i = 0; i<  EXYNOS_AUDSS_MAX_CLKS; i++) {
>> +               if (!IS_ERR_OR_NULL(clk_table[i]))
>> +                       clk_unregister(clk_table[i]);
>> +       }
>
>
> Since we only get here if all the clocks are registered properly and we
> always register EXYNOS_AUDSS_MAX_CLKS clocks, couldn't this simply be:
>
>
>         for (i = 0; i < EXYNOS_AUDSS_MAX_CLKS; i++)
>                 clk_unregister(clk_table[i]);
>
> ?

Once support is added for Exynos5420, we won't always register
EXYNOS_AUDSS_MAX_CLKS clocks, so we'd still need the NULL check.

Thanks,
Andrew
