Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaKOO2H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 09:28:07 -0500
Received: from gloria.sntech.de ([95.129.55.99]:52770 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbaKOO2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 09:28:05 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Thomas Abraham <thomas.ab@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Max Schwarz <max.schwarz@online.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH] clk-divider: Fix READ_ONLY when divider > 1
Date: Sat, 15 Nov 2014 15:31:06 +0100
Message-ID: <2145155.R4QWixMtmU@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1415979129-21325-1-git-send-email-james.hogan@imgtec.com>
References: <1415979129-21325-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Am Freitag, 14. November 2014, 15:32:09 schrieb James Hogan:
> Commit 79c6ab509558 (clk: divider: add CLK_DIVIDER_READ_ONLY flag) in
> v3.16 introduced the CLK_DIVIDER_READ_ONLY flag which caused the
> recalc_rate() and round_rate() clock callbacks to be omitted.
> 
> However using this flag has the unfortunate side effect of causing the
> clock recalculation code when a clock rate change is attempted to always
> treat it as a pass-through clock, i.e. with a fixed divide of 1, which
> may not be the case. Child clock rates are then recalculated using the
> wrong parent rate.
> 
> Therefore instead of dropping the recalc_rate() and round_rate()
> callbacks, alter clk_divider_bestdiv() to always report the current
> divider as the best divider so that it is never altered.
> 
> For me the read only clock was the system clock, which divided the PLL
> rate by 2, from which both the UART and the SPI clocks were divided.
> Initial setting of the UART rate set it correctly, but when the SPI
> clock was set, the other child clocks were miscalculated. The UART clock
> was recalculated using the PLL rate as the parent rate, resulting in a
> UART new_rate of double what it should be, and a UART which spewed forth
> garbage when the rate changes were propagated.
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Heiko Stuebner <heiko@sntech.de>
> Cc: Thomas Abraham <thomas.ab@samsung.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Max Schwarz <max.schwarz@online.de>
> Cc: <stable@vger.kernel.org> # v3.16+

Yep, your solution is much better I think.
Reviewed-by: Heiko Stuebner <heiko@sntech.de>


Heiko
