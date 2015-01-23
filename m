Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbbAWRlC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:41:02 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60919 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbbAWRk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:40:59 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-c3-54c28718db8f
Message-id: <54C287A0.50407@samsung.com>
Date: Fri, 23 Jan 2015 18:40:48 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: tomasz.figa@gmail.com, mturquette@linaro.org, kgene@kernel.org,
        pankaj.dubey@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, sw0312.kim@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/12] clk: samsung: exynos5433: Add clocks using common
 clock framework
References: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
 <1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1421821618-8627-2-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xy7oS7YdCDPqOmlhc3q9tcf3Lc1aL
	SfcnsFj0P37NbHF51xw2ixnn9zFZPJ1wkc1i0dYv7BYzJr9ks1i16w+jA5fHzll32T02repk
	87hzbQ+bR9+WVYwenzfJBbBGcdmkpOZklqUW6dslcGU8/fqcteAXe8XcZXuZGhh3sHUxcnJI
	CJhITJzyH8oWk7hwbz2QzcUhJLCUUaLx9RJWCOcTo8SZI/8YQap4BTQkVs1tAbNZBFQlfp2+
	ywJiswkYSvQe7QOLiwpESJy8u4cdol5Q4sfke2A1IkC9M/9eAathFnjDKPGi06uLkYNDWCBR
	Yvc6LpCwkEC9xPLNbcwgNqeAq8Tl3z8YQUqYBfQk7l/UguiUl9i85i3zBEaBWUgWzEKomoWk
	agEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkOD/soNx8TGrQ4wCHIxKPLw7nh4MEWJN
	LCuuzD3EKMHBrCTCm5FyKESINyWxsiq1KD++qDQntfgQIxMHp1QDI0P5WSOfOTIPtBebCzpf
	upKTM6ekJU9oZqU1Y8IGlmubRN5++3pZazKvVJK/s9708uXut69MPu2ht7D/y87Vj9rapAxz
	Va1U81KWX4ztK1sUmReRftmTPWrR9KfH3xXeO21+Zn6ItNXGvf6acT9f3GK5Z7rte9+FPTYR
	FQs+fHFg1Xwt2B/TpcRSnJFoqMVcVJwIABACuLNcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/15 07:26, Chanwoo Choi wrote:
> +/* list of all parent clock list */

> +PNAME(mout_bus_pll_user_p)	= { "fin_pll", "sclk_bus_pll", };
...
> +
> +static struct samsung_mux_clock top_mux_clks[] __initdata = {

> +	MUX(CLK_MOUT_BUS_PLL_USER, "mout_bus_pll_user", mout_bus_pll_user_p,
> +			MUX_SEL_TOP1, 0, 1),
...
> +};
> +
> +static struct samsung_div_clock top_div_clks[] __initdata = {
...
> +	/* DIV_TOP3 */
> +	DIV(CLK_DIV_ACLK_IMEM_SSSX_266, "div_aclk_imem_sssx_266",
> +			"mout_bus_pll_user", DIV_TOP3, 24, 3),

Shouldn't "fin_pll" be renamed to "oscclk" ? In the documentation
the root clock (from XXTI input pin) seems to be referred as OSCCLK.
And I can't see "fin_pll" clock registered anywhere. Shouldn't there
be a "fixed-rate-clock" as a parent of at least CMU_TOP? e.g.

xxti: xxti {
	compatible = "fixed-clock";
	#clock-cells = <0>;
	clock-output-names = "oscclk";
	clock-frequency = <24000000>;
};

&cmu_top {
	clocks = <&xxti>;
};

--
Regards,
Sylwester
