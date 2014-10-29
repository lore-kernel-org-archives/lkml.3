Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaJ2T0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:26:34 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:45330 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbaJ2T0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:26:33 -0400
MIME-Version: 1.0
In-Reply-To: <7h38a68zu9.fsf@deeprootsystems.com>
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
	<1414583525-17395-5-git-send-email-zyw@rock-chips.com>
	<7h38a68zu9.fsf@deeprootsystems.com>
Date: Wed, 29 Oct 2014 12:26:32 -0700
X-Google-Sender-Auth: TI3KHwByzDm6Zv9mabw5JU5iV6A
Message-ID: <CAD=FV=Vabh6xJOYxkuGiG_AFr2qm26iqL87LJ_CBzK1w+dC9XA@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] ARM: rockchip: add suspend and resume for RK3288
From: Doug Anderson <dianders@chromium.org>
To: Kevin Hilman <khilman@kernel.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin,

On Wed, Oct 29, 2014 at 12:01 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> +     /* set bit 8 so that system will resume to FAST_BOOT_ADDR */
>> +     regmap_write(sgrf_regmap, RK3288_SGRF_SOC_CON0,
>> +                  BIT(SGRF_FAST_BOOT_EN) | BIT(SGRF_FAST_BOOT_EN + 16));
>
> Comment says "bit 8", but code says bit 8 and bit 24, and if bit 24 is
> needed, it should probably get its own #define in the header.

This is Rockchip's "write enable" feature hitting us again.  The upper
16-bits are "write enables" for the lower 16-bits.  So to set bit 8
you set bit 8 to whatever value you want and then 'write enable' by
setting (1 << 8 << 16).  It allows you to avoid read-modify-write.
See this in Rockchip's clk.h:

#define HIWORD_UPDATE(val, mask, shift) \
                ((val) << (shift) | (mask) << ((shift) + 16))
