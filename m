Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaL1UvY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 15:51:24 -0500
Received: from gloria.sntech.de ([95.129.55.99]:36514 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaL1UvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 15:51:23 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Roger Chen <roger.chen@rock-chips.com>
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, eddie.cai@rock-chips.com
Subject: Re: [PATCH v2 2/6] GMAC: define clock ID used for GMAC
Date: Sun, 28 Dec 2014 21:51:14 +0100
Message-ID: <1490915.LqZ81LD0Jb@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1417056766-3678-1-git-send-email-roger.chen@rock-chips.com>
References: <1417056591-3570-1-git-send-email-roger.chen@rock-chips.com> <1417056766-3678-1-git-send-email-roger.chen@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

patches modifying the rockchip clock parts should have a subject like
	clk: rockchip: .....

Same for the following patch

Am Donnerstag, 27. November 2014, 10:52:46 schrieb Roger Chen:
> Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
> ---
>  include/dt-bindings/clock/rk3288-cru.h |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/include/dt-bindings/clock/rk3288-cru.h
> b/include/dt-bindings/clock/rk3288-cru.h index 100a08c..f9496f5 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -72,6 +72,10 @@
>  #define SCLK_HEVC_CABAC		111
>  #define SCLK_HEVC_CORE		112
> 
> +#define SCLK_MAC_PLL		150

Why do you need to export the mac pll source selection?
I understand SCLK_MAC below, as you will want to select ext_gmac explicitly if 
available. But otherwise, why would you need to explicitly select the pll 
source?

The clock framework is intelligent enough that when you do a 
clk_set_rate(sclk_mac, 50000000) for example that it will select the best pll 
source + best divider to provide the most accurate frequency for this, so 
there should be no need to handle the pll source manually.


Heiko

> +#define SCLK_MAC		151
> +#define SCLK_MACREF_OUT		152
> +
>  #define DCLK_VOP0		190
>  #define DCLK_VOP1		191

