Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaJMQLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 12:11:24 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:61330 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaJMQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 12:11:21 -0400
MIME-Version: 1.0
In-Reply-To: <1413012563-7690-2-git-send-email-caesar.wang@rock-chips.com>
References: <1413012563-7690-1-git-send-email-caesar.wang@rock-chips.com>
	<1413012563-7690-2-git-send-email-caesar.wang@rock-chips.com>
Date: Mon, 13 Oct 2014 09:11:20 -0700
X-Google-Sender-Auth: Z5eCysCjc13uTlGK2ZVK1_fEhfU
Message-ID: <CAD=FV=XHe65wwf8Q9RA0ZDgb5oQLdyjuZDFy4mD01_t6G6WnHQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/5] thermal: rockchip: add driver for thermal
From: Doug Anderson <dianders@chromium.org>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        zyf <zyf@rock-chips.com>, linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Eddie Cai <cf@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Derek Basehore <dbasehore@chromium.org>,
        Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?6ZmI5riQ6aOe?= <cjf@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Caesar,

On Sat, Oct 11, 2014 at 12:29 AM, Caesar Wang
<caesar.wang@rock-chips.com> wrote:

> +static void rk_tsadcv2_initialize(int reset_mode, int chn, void __iomem *regs,
> +                                 unsigned long hw_shut_temp)
> +{
> +       u32 shutdown_value;
> +
> +       shutdown_value = rk_tsadcv2_temp_to_code(hw_shut_temp);
> +
> +       /* Enable measurements at ~ 10 Hz */
> +       writel_relaxed(0 | TSADCV2_AUTO_TSHUT_POLARITY_HIGH, regs +
> +                      TSADCV2_AUTO_CON);
> +       writel_relaxed(TSADCV2_AUTO_PERIOD_TIME, regs + TSADCV2_AUTO_PERIOD);
> +       writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME, regs +
> +                      TSADCV2_AUTO_PERIOD_HT);
> +       writel_relaxed(shutdown_value, regs + TSADCV2_COMP_SHUT(chn));
> +       writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_TIME, regs +
> +                      TSADCV2_HIGHT_INT_DEBOUNCE);
> +       writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME, regs +
> +                      TSADCV2_HIGHT_TSHUT_DEBOUNCE);
> +
> +       if (reset_mode == GPIO)
> +               writel_relaxed(TSADCV2_SHUT_2GPIO_SRC_EN(chn) |
> +                              TSADCV2_INT_SRC_EN(chn), regs +
> +                              TSADCV2_INT_EN);
> +       else
> +               writel_relaxed(TSADCV2_SHUT_2CRU_SRC_EN(chn) |
> +                              TSADCV2_INT_SRC_EN(chn) , regs +
> +                              TSADCV2_INT_EN);
> +
> +       writel_relaxed(TSADCV2_AUTO_SRC_EN(chn) | TSADCV2_AUTO_EN, regs +
> +                      TSADCV2_AUTO_CON);

Aren't you clobbering the polarity here?

NOTE: I didn't do a full review of this driver, just noticed that
while looking at another patch and figure'd I'd respond here, too.
