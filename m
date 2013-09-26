Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3IZOAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:00:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44565 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3IZOAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:00:43 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-e4-52443e08cfd3
From: Tomasz Figa <t.figa@samsung.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Yadwinder Singh <yadi.brar@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>, rob@landley.net,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, ijc+devicetree@hellion.org.uk,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, ben-linux@fluff.org,
        s.nawrocki@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] clk: samsung: Add clock driver for s5pc100
Date: Thu, 26 Sep 2013 16:00:28 +0200
Message-id: <3392871.UAAWoO4asY@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <CAKew6eUgpnqvZUCsWGpqwDXtp6ARmhd-Nw-BXiod8=MK-k0fUA@mail.gmail.com>
References: <1380041605-15736-1-git-send-email-m.krawczuk@partner.samsung.com>
 <1380041605-15736-2-git-send-email-m.krawczuk@partner.samsung.com>
 <CAKew6eUgpnqvZUCsWGpqwDXtp6ARmhd-Nw-BXiod8=MK-k0fUA@mail.gmail.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t/xy7qcdi5BBlfyLSatO8BkMf/IOVaL
	c69WMlqcbXrDbrHp8TVWi8u75rBZzDi/j8ni9JpTzBZLr19ksng64SKbxYTpa1ksDq8Aalv3
	cjqQ9aad1eLVwTYWi7m/G1kt5kx/x+Qg6LFm3hpGjwWfr7B7/F31gtlj56y77B4rl39h83i1
	eiarx51re9g8Ni+p9zj4bg+TR9+WVYwenzfJeWycGxrAE8Vlk5Kak1mWWqRvl8CVse1lTkGX
	YMXiuX+ZGxiv83QxcnJICJhIXP81hRnCFpO4cG89WxcjF4eQwFJGia8HD7NAOF1MEtNanrGC
	VLEJqEl8bnjEBmKLCBhITFwyjxWkiFlgMqtE44W7TCAJYQFnie/HboA1sAioStztOsXexcjB
	wSugKdF7xREkzC+gLvFu21OwclEBV4lPCzeyg9icAsES37buhVp8i1Hiwdz5YAleAUGJH5Pv
	sYDYzALyEvv2T2WFsLUk1u88zjSBUXAWkrJZSMpmISlbwMi8ilE0tTS5oDgpPddQrzgxt7g0
	L10vOT93EyMkRr/sYFx8zOoQowAHoxIPryabc5AQa2JZcWXuIUYJDmYlEd5WDZcgId6UxMqq
	1KL8+KLSnNTiQ4xMHJxSDYzd59LtXzxZ1Vjk1Hb+/7srZsz+pVxCa4/Ndft80Z195rFnU4/E
	q1cWpX2c+1zm3f3FvpYr5gt1BnitPysp6LvikcGBZVdbe5O2tIp/vLWh78X51UnXbR39V4q9
	l9gQceLRekFLmS83z65MzTNM32596MF0n1/fjQsDHkl3X1ldFl9vf62dqzdSiaU4I9FQi7mo
	OBEA5Ql0ta8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yadwinder,

I haven't reviewed this series yet, but let me clarify some things from
your comments.

On Thursday 26 of September 2013 17:38:58 Yadwinder Singh Brar wrote:
> > +
> > +/* Helper macros to define clock arrays. */
> > +#define FIXED_RATE_CLOCKS(name)        \
> > +               static struct samsung_fixed_rate_clock name[]
> > +#define MUX_CLOCKS(name)       \
> > +               static struct samsung_mux_clock name[]
> > +#define DIV_CLOCKS(name)       \
> > +               static struct samsung_div_clock name[]
> > +#define GATE_CLOCKS(name)      \
> > +               static struct samsung_gate_clock name[]
> > +
> 
> These macros seems little bit odd in our common practice,
> perhaps these are making code harder to read below.
> 

They allow array declaration to fit into single line. I agree that it is
not particularly easy to read at first sight, but shouldn't really be
much of nuisance. In addition, most of this driver is based on macros
like this, e.g. GATE(), MUX(), PNAME(), etc.

> > +PNAME(mout_i2s_2_p) = {
> > +       "fout_epll",
> > +       "i2scdclk0",
> > +       "dout_audio0",
> > +       "none"
> > +};
> > +
> 
> Using one line per parent isn't increasing length of file unnecessarily?

I believe this improves readability. Do we really care about size of
source code that much, over readability?

> > +       ALIAS(SCLK_AUDIO0, "soc-audio.0", "sclk_audio"),
> > +       ALIAS(SCLK_AUDIO1, "soc-audio.1", "sclk_audio"),
> > +       ALIAS(SCLK_AUDIO2, "soc-audio.2", "sclk_audio"),
> > +       ALIAS(KEYIF, NULL, "keypad"),
> > +
> > +       ALIAS(MFC, "s5p-mfc", "sclk_mfc"),
> > +       ALIAS(G2D, "s5p-g2d", "fimg2d"),
> > +
> > +};
> > +
> 
> Any reason/hidden advantage for using a separate of ALIAS,
> instead of using MUX_A/GATE_A ?

Yes, not even hidden. Alias is not a property of clock. One clock can
have multiple aliases, e.g. the same clock being input to multiple
devices.

In addition, as soon as we fully move s5pv210 to device tree, the whole
array of aliases will be dropped, without the need to touch the main
clock arrays at all.

Best regards,
Tomasz

