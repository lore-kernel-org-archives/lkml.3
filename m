Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbbAGOMG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:12:06 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:38578 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbAGOMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:12:03 -0500
Message-ID: <54AD3EAE.6090009@gmail.com>
Date: Wed, 07 Jan 2015 15:11:58 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
To: Jisheng Zhang <jszhang@marvell.com>, mturquette@linaro.org,
        sboyd@codeaurora.org, alexandre.belloni@free-electrons.com,
        antoine.tenart@free-electrons.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] clk: berlin: bg2q: remove non-exist "smemc" gate
 clock
References: <1420016272-6789-1-git-send-email-jszhang@marvell.com> <1420016272-6789-4-git-send-email-jszhang@marvell.com>
In-Reply-To: <1420016272-6789-4-git-send-email-jszhang@marvell.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.12.2014 09:57, Jisheng Zhang wrote:
> The "smemc" clock is removed on BG2Q SoCs. In fact, bit19 of clkenable
> register is for nfc. Current code use bit19 for non-exist "smemc"
> incorrectly, this prevents eMMC from working due to the sdhci's
> "core" clk is still gated.
>
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> Cc: stable@vger.kernel.org # 3.16+
> ---
>   drivers/clk/berlin/bg2q.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
> index 21784e4..440ef81 100644
> --- a/drivers/clk/berlin/bg2q.c
> +++ b/drivers/clk/berlin/bg2q.c
> @@ -285,7 +285,6 @@ static const struct berlin2_gate_data bg2q_gates[] __initconst = {
>   	{ "pbridge",	"perif",	15, CLK_IGNORE_UNUSED },
>   	{ "sdio",	"perif",	16, CLK_IGNORE_UNUSED },
>   	{ "nfc",	"perif",	18 },
> -	{ "smemc",	"perif",	19 },

Jisheng,

if bit 19 is for nfc, how does that work out with bit 18 which is
still assigned to nfc? Can you re-evaluate clkenable registers for
BG2Q and fix it up accordingly? I'd suggest to still disable as many
clocks as possible rather than removing the corresponding clk_gates.

Sebastian

>   	{ "pcie",	"perif",	22 },
>   };
>
>

