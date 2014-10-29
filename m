Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbaJ2UAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:00:22 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39568 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251AbaJ2UAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:00:17 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list\:ARM\/Rockchip SoC..." 
	<linux-rockchip@lists.infradead.org>,
        Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 4/7] ARM: rockchip: add suspend and resume for RK3288
References: <1414583525-17395-1-git-send-email-zyw@rock-chips.com>
	<1414583525-17395-5-git-send-email-zyw@rock-chips.com>
	<7h38a68zu9.fsf@deeprootsystems.com>
	<CAD=FV=Vabh6xJOYxkuGiG_AFr2qm26iqL87LJ_CBzK1w+dC9XA@mail.gmail.com>
Date: Wed, 29 Oct 2014 13:00:14 -0700
In-Reply-To: <CAD=FV=Vabh6xJOYxkuGiG_AFr2qm26iqL87LJ_CBzK1w+dC9XA@mail.gmail.com>
	(Doug Anderson's message of "Wed, 29 Oct 2014 12:26:32 -0700")
Message-ID: <7hy4ry7ik1.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson <dianders@chromium.org> writes:

> Kevin,
>
> On Wed, Oct 29, 2014 at 12:01 PM, Kevin Hilman <khilman@kernel.org> wrote:
>>> +     /* set bit 8 so that system will resume to FAST_BOOT_ADDR */
>>> +     regmap_write(sgrf_regmap, RK3288_SGRF_SOC_CON0,
>>> +                  BIT(SGRF_FAST_BOOT_EN) | BIT(SGRF_FAST_BOOT_EN + 16));
>>
>> Comment says "bit 8", but code says bit 8 and bit 24, and if bit 24 is
>> needed, it should probably get its own #define in the header.
>
> This is Rockchip's "write enable" feature hitting us again.  The upper
> 16-bits are "write enables" for the lower 16-bits.  So to set bit 8
> you set bit 8 to whatever value you want and then 'write enable' by
> setting (1 << 8 << 16).  It allows you to avoid read-modify-write.
> See this in Rockchip's clk.h:
>
> #define HIWORD_UPDATE(val, mask, shift) \
>                 ((val) << (shift) | (mask) << ((shift) + 16))

OK, sounds like a macro is needed in the core code as well (with a
comment for those of us who will forget why it's needed)

Kevin
