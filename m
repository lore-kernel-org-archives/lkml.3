Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaJXEoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:44:39 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:34801 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358AbaJXEoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:44:37 -0400
MIME-Version: 1.0
In-Reply-To: <1413933928-25803-1-git-send-email-zyw@rock-chips.com>
References: <1413933461-25602-1-git-send-email-zyw@rock-chips.com>
	<1413933928-25803-1-git-send-email-zyw@rock-chips.com>
Date: Thu, 23 Oct 2014 21:44:36 -0700
X-Google-Sender-Auth: It-DNV0rvidrIBSK5fUbHi7_sTM
Message-ID: <CAD=FV=XOvPP+2yJ10e03ko9iWmyU7BawrVyA6Dqt8RkSDMXgTg@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] ARM: rockchip: add suspend and resume for RK3288
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Heiko Stuebner <heiko@sntech.de>, Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tony Xie <xxx@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris,

On Tue, Oct 21, 2014 at 4:25 PM, Chris Zhong <zyw@rock-chips.com> wrote:
> +static inline void rk3288_copy_data_to_sram(void)
> +{
> +       u32 resume_code_size = (u32)&rkpm_bootdata_cpu_code -
> +                              (u32)rockchip_slp_cpu_resume + 4;
> +
> +       /* save root sram data in ddr mem */
> +       memcpy(rk3288_bootram_base, bootram_save_data, SZ_4K);

I swore we looked at this before, but the above memcpy is backwards.

> +       /* move resume code and data to bootsram */
> +       memcpy(rk3288_bootram_base, rockchip_slp_cpu_resume,
> +              resume_code_size);
> +}
> +
> +static inline void rk3288_restore_original_sram(void)
> +{
> +       memcpy(bootram_save_data, rk3288_bootram_base, SZ_4K);

This one too.
