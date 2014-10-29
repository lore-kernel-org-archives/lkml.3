Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbaJ2Tst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:48:49 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50518 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698AbaJ2Tsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:48:46 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        xjq@rock-chips.com, hj@rock-chips.com, huangtao@rock-chips.com,
        dkl@rock-chips.com, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: change PLL setting for better clock jitter
Date: Wed, 29 Oct 2014 20:51:50 +0100
Message-ID: <2603477.gAdFcjx3UJ@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1412918637-9843-1-git-send-email-kever.yang@rock-chips.com>
References: <1412918637-9843-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 9. Oktober 2014, 22:23:57 schrieb Kever Yang:
> dclk_vop0/1 is the source of HDMI TMDS clock in rk3288, usually we
> use 594MHz for clock source of dclk_vop0/1.
> 
> HDMI CTS 7-9 require TMDS Clock jitter is lower than 0.25*Tbit:
> TMDS clock(MHz)		CTS require jitter (ps)
> 	297		84.2
> 	148.5		168
> 	74.25		336
> 	27		1247
> 
> PLL BW and VCO frequency effects the jitter of PLL output clock,
> clock jitter is better if BW is lower or VCO frequency is higher.
> 
> If PLL use default setting of RK3066_PLL_RATE( 594000000, 2, 198, 4),
> the TMDS Clock jitter is higher than 250ps, which means we can't
> pass the test when TMDS clock is 297MHz or 148.5MHz.
> 
> If we use RK3066_PLL_RATE_BWADJ(594000000, 1, 198, 8, 1),
> the TMDS Clock jitter is about 60ps and we can pass all test case.
> 
> So we need this patch to make hdmi si test pass.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

I've applied this to my v3.19-clk branch with Dougs Review-Tag.


Heiko
