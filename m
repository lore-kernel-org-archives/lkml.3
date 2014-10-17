Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaJQN5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 09:57:03 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:55213 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaJQN47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 09:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFoHkr-Z3PY0tTw9BPF8gJY_bVLtJL2KK7_uoq_008ymnw@mail.gmail.com>
References: <1413457353-4222-1-git-send-email-jinkun.hong@rock-chips.com>
	<1413457353-4222-2-git-send-email-jinkun.hong@rock-chips.com>
	<CAPDyKFoHkr-Z3PY0tTw9BPF8gJY_bVLtJL2KK7_uoq_008ymnw@mail.gmail.com>
Date: Fri, 17 Oct 2014 15:56:57 +0200
X-Google-Sender-Auth: 0iN_0PL_Sar0v-apeAVJdrflwRk
Message-ID: <CAMuHMdUPCP2BZUBmLaxzxAnKM7U73UGu_wsuswHtEYm2aYurxg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] power-domain: add power domain drivers for
 Rockchip platform
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "jinkun.hong" <jinkun.hong@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Jack Dai <jack.dai@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ulf,

On Thu, Oct 16, 2014 at 3:06 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> +
>> +       ret = pm_clk_create(dev);
>> +       if (ret) {
>> +               dev_err(dev, "pm_clk_create failed %d\n", ret);
>> +               return;
>> +       };
>> +
>> +       while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
>> +               ret = pm_clk_add_clk(dev, clk);
>> +               if (ret) {
>> +                       dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
>> +                       goto clk_err;
>> +               };
>> +       }
>> +
>> +       if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
>
> Could you elaborate on why you need to do this check here?

If runtime PM is enabled, the clocks are managed by runtime PM, and will
be enabled/disabled later when needed.

If runtime PM is disabled, the clocks are not managed by runtime PM,
so they should be enabled at initialization time.

Grygorii and I do the same thing for keystone resp. pm-rmobile.

> When I see a check for IS_ENABLED(CONFIG_PM_RUNTIME), that indicates
> to me that we actually have an another issue, perhaps in the PM clk
> API.

Good point. Perhaps this can be handled in pm_clk_add() instead?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
