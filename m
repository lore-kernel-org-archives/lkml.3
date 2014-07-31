Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaGaNH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:07:29 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:35114 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbaGaNH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:07:26 -0400
Message-ID: <53DA3F86.3020506@gmail.com>
Date: Thu, 31 Jul 2014 15:07:18 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Silva Naves <hsnaves@gmail.com>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv2 5/5] clk: samsung: exynos5410: Added clocks DPLL, EPLL,
 IPLL, and VPLL
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com> <1406805732-17372-6-git-send-email-hsnaves@gmail.com>
In-Reply-To: <1406805732-17372-6-git-send-email-hsnaves@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Humberto,

You can find my comments inline.

On 31.07.2014 13:22, Humberto Silva Naves wrote:
> Added the remaining PLL clocks, and also added the configuration
> tables with the PLL coefficients for the supported frequencies.
> These frequency tables are only installed when a 24MHz clock is
> supplied as the input clock source. To reflect these changes, new
> constants were added to the dt-bindings file.

[snip]

> +static struct samsung_pll_rate_table apll_24mhz_tbl[] __initdata = {
> +	/* sorted in descending order */
> +	/* PLL_35XX_RATE(rate, m, p, s) */
> +	PLL_35XX_RATE(2100000000, 175, 2, 0),
> +	PLL_35XX_RATE(2000000000, 250, 3, 0),
> +	PLL_35XX_RATE(1900000000, 475, 6, 0),
> +	PLL_35XX_RATE(1800000000, 225, 3, 0),
> +	PLL_35XX_RATE(1700000000, 425, 6, 0),
> +	PLL_35XX_RATE(1600000000, 200, 3, 0),
> +	PLL_35XX_RATE(1500000000, 250, 4, 0),
> +	PLL_35XX_RATE(1400000000, 175, 3, 0),
> +	PLL_35XX_RATE(1300000000, 325, 6, 0),
> +	PLL_35XX_RATE(1200000000, 100, 2, 0),
> +	PLL_35XX_RATE(1100000000, 275, 3, 1),
> +	PLL_35XX_RATE(1000000000, 250, 3, 1),
> +	PLL_35XX_RATE(900000000, 150, 2, 1),
> +	PLL_35XX_RATE(800000000, 200, 3, 1),
> +	PLL_35XX_RATE(700000000, 175, 3, 1),
> +	PLL_35XX_RATE(600000000, 100, 2, 1),
> +	PLL_35XX_RATE(500000000, 250, 3, 2),
> +	PLL_35XX_RATE(400000000, 200, 3, 2),
> +	PLL_35XX_RATE(300000000, 100, 2, 2),
> +	PLL_35XX_RATE(200000000, 200, 3, 3),

nit: The numbers could be aligned to the right using spaces (see exynos4.c).

> +	{ },
> +};
> +
> +static struct samsung_pll_rate_table cpll_24mhz_tbl[] __initdata = {
> +	/* sorted in descending order */
> +	/* PLL_35XX_RATE(rate, m, p, s) */
> +	PLL_35XX_RATE(666000000, 222, 4, 1),
> +	PLL_35XX_RATE(640000000, 160, 3, 1),
> +	PLL_35XX_RATE(320000000, 160, 3, 2),
> +	{ },
> +};
> +
> +static struct samsung_pll_rate_table dpll_24mhz_tbl[] __initdata = {
> +	/* sorted in descending order */
> +	/* PLL_35XX_RATE(rate, m, p, s) */
> +	PLL_35XX_RATE(600000000, 200, 4, 1),
> +	{ },
> +};
> +
> +static struct samsung_pll_rate_table epll_24mhz_tbl[] __initdata = {
> +	/* sorted in descending order */
> +	/* PLL_36XX_RATE(rate, m, p, s, k) */
> +	PLL_36XX_RATE(600000000, 100, 2, 1,      0),
> +	PLL_36XX_RATE(400000000, 200, 3, 2,      0),
> +	PLL_36XX_RATE(200000000, 200, 3, 3,      0),
> +	PLL_36XX_RATE(180633600, 301, 5, 3,  -3670),
> +	PLL_36XX_RATE( 67737600, 452, 5, 5, -27263),
> +	PLL_36XX_RATE( 49152000, 197, 3, 5, -25690),
> +	PLL_36XX_RATE( 45158401, 181, 3, 5, -24012),

Have you ensured that the rates specified match the rates calculated
using PLL equation? You can find how it is calculated in recalc_rate
callback of this particular PLL type in clk-pll.c.

As a side note, the PLL registration code should be made a bit more
robust and just calculate the rates itself and printing warnings if they
don't match the entered ones. I definitely need more hours in a day, so
much to do. ;)

> +	{ },
> +};
> +
> +static struct samsung_pll_rate_table ipll_24mhz_tbl[] __initdata = {
> +	/* sorted in descending order */
> +	/* PLL_35XX_RATE(rate, m, p, s, k) */
> +	PLL_35XX_RATE(864000000, 288, 4, 1),
> +	PLL_35XX_RATE(666000000, 222, 4, 1),
> +	PLL_35XX_RATE(432000000, 288, 4, 2),
> +	{ },
> +};
> +
> +static struct samsung_pll_rate_table kpll_24mhz_tbl[] __initdata = {
> +	/* sorted in descending order */
> +	/* PLL_35XX_RATE(rate, m, p, s) */
> +	PLL_35XX_RATE(1500000000, 250, 4, 0),
> +	PLL_35XX_RATE(1400000000, 175, 3, 0),
> +	PLL_35XX_RATE(1300000000, 325, 6, 0),
> +	PLL_35XX_RATE(1200000000, 100, 2, 0),
> +	PLL_35XX_RATE(1100000000, 275, 3, 1),
> +	PLL_35XX_RATE(1000000000, 250, 3, 1),
> +	PLL_35XX_RATE(900000000, 150, 2, 1),
> +	PLL_35XX_RATE(800000000, 200, 3, 1),
> +	PLL_35XX_RATE(700000000, 175, 3, 1),
> +	PLL_35XX_RATE(600000000, 100, 2, 1),
> +	PLL_35XX_RATE(500000000, 250, 3, 2),
> +	PLL_35XX_RATE(400000000, 200, 3, 2),
> +	PLL_35XX_RATE(300000000, 100, 2, 2),
> +	PLL_35XX_RATE(200000000, 200, 3, 3),

nit: Alignment.

Otherwise looks good, thanks.

Best regards,
Tomasz
