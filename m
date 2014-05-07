Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934184AbaEGNgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:36:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34336 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933191AbaEGNgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:36:33 -0400
Message-ID: <536A36A2.5030109@ti.com>
Date: Wed, 7 May 2014 19:05:30 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, <stern@rowland.harvard.edu>,
        <hdegoede@redhat.com>
CC: Boris Brezillon <boris@free-electrons.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <kevin.z.m.zh@gmail.com>, <sunny@allwinnertech.com>,
        <shuge@allwinnertech.com>, <zhuzhenhua@allwinnertech.com>,
        <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 3/7] phy: usb: sunxi: Introduce Allwinner A31 USB PHY
 support
References: <1399434623-20383-1-git-send-email-maxime.ripard@free-electrons.com> <1399434623-20383-4-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1399434623-20383-4-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 07 May 2014 09:20 AM, Maxime Ripard wrote:
> The USB phy controller in the A31 differs mostly from the older controllers
> because it has a clock dedicated for each phy, while the older ones were having
> a single clock for all the phys.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/phy/phy-sun4i-usb.c | 35 ++++++++++++++++++++++++++---------
>  1 file changed, 26 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/phy/phy-sun4i-usb.c b/drivers/phy/phy-sun4i-usb.c
> index e6e6c4ba7145..1d83abe07a29 100644
> --- a/drivers/phy/phy-sun4i-usb.c
> +++ b/drivers/phy/phy-sun4i-usb.c
> @@ -61,16 +61,17 @@
>  #define MAX_PHYS			3
>  
>  struct sun4i_usb_phy_data {
> -	struct clk *clk;
>  	void __iomem *base;
>  	struct mutex mutex;
>  	int num_phys;
>  	u32 disc_thresh;
> +	bool dedicated_clocks;

Don't think we need this structure member as it's been used only in probe.

Thanks
Kishon
