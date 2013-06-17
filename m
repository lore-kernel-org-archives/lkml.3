Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3FQPVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:21:44 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:29464
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069Ab3FQPVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:21:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 17 Jun 2013 23:22:35 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH v2 1/5] clk: divider: replace bitfield width with mask
Message-ID: <20130617152233.GK31687@S2101-09.ap.freescale.net>
References: <1371437905-15567-1-git-send-email-mturquette@linaro.org>
 <1371437905-15567-2-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1371437905-15567-2-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 16, 2013 at 07:58:21PM -0700, Mike Turquette wrote:
> The forthcoming Device Tree binding for the divider clock type will use
> a bitfield mask instead of bitfield width, which is what the current
> basic divider implementation uses.
> 
> This patch replaces the u8 width in struct clk_divider with a u32 mask.
> The divider code is updated to use the bit mask internally but the two
> registration functions still accept the width to maintain compatibility
> with existing users.
> 
> Also updated in this patch is the clk-private.h divider macro and two
> Freescale clock divider implementations that are based on struct
> clk_divider.
> 
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
> No change since v1, new patch
> 
>  arch/arm/mach-imx/clk-busy.c |  2 +-
>  drivers/clk/clk-divider.c    | 31 +++++++++++++++----------------
>  drivers/clk/mxs/clk-div.c    |  2 +-
>  include/linux/clk-private.h  |  2 +-
>  include/linux/clk-provider.h |  2 +-
>  5 files changed, 19 insertions(+), 20 deletions(-)

On imx and mxs,

Tested-by: Shawn Guo <shawn.guo@linaro.org>

