Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbaE3Q3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:29:07 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:37536 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbaE3Q3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:29:04 -0400
MIME-Version: 1.0
In-Reply-To: <53888EF5.5090800@collabora.co.uk>
References: <1401398496-4624-1-git-send-email-dianders@chromium.org>
	<53888EF5.5090800@collabora.co.uk>
Date: Fri, 30 May 2014 09:29:03 -0700
X-Google-Sender-Auth: JYyoGz3vGf849cZzW_H0lWVOl4U
Message-ID: <CAD=FV=XREX4HkLtBLoie++w1FMMN+BOtB=1EOC3My66zOPizjw@mail.gmail.com>
Subject: Re: [PATCH] clk: exynos5420: Keep aclk66_peric enabled during boot
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Tomasz Figa <t.figa@samsung.com>, Mike Turquette <mturquette@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Fri, May 30, 2014 at 7:00 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
>> @@ -1239,3 +1251,15 @@ static void __init exynos5800_clk_init(struct device_node *np)
>>       exynos5x_clk_init(np, EXYNOS5800);
>>  }
>>  CLK_OF_DECLARE(exynos5800_clk, "samsung,exynos5800-clock", exynos5800_clk_init);
>> +
>> +static int __init exynos5420_clk_late_init(void)
>> +{
>> +     int i;
>> +
>> +     for (i = 0; i < ARRAY_SIZE(boot_clocks); i++) {
>> +             struct clk *to_disable = __clk_lookup(boot_clocks[i]);
>> +
>> +             clk_disable_unprepare(to_disable);
>> +     }
>> +}
>> +late_initcall(exynos5420_clk_late_init);
>>
>
> You should return 0 here.

Duh.  Done.
