Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbaKAItv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 04:49:51 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35995 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaKAItt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 04:49:49 -0400
Message-ID: <54549EA6.5060007@collabora.co.uk>
Date: Sat, 01 Nov 2014 09:49:42 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>
CC: Heiko Stuebner <heiko@sntech.de>, Chris Zhong <zyw@rock-chips.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: of: Add support for parsing microvolts
 for suspend state
References: <1414813978-32233-1-git-send-email-dianders@chromium.org> <1414813978-32233-2-git-send-email-dianders@chromium.org>
In-Reply-To: <1414813978-32233-2-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 11/01/2014 04:52 AM, Doug Anderson wrote:
> Leverage all the work that was done in (40e20d6 regulator: of: Add
> support for parsing regulator_state for suspend state) and throw in
> the ability to set suspend microvolts from the device tree.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/regulator/of_regulator.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
> index f0d19fc..7fe93c5 100644
> --- a/drivers/regulator/of_regulator.c
> +++ b/drivers/regulator/of_regulator.c
> @@ -107,6 +107,10 @@ static void of_get_regulation_constraints(struct device_node *np,
>  					"regulator-off-in-suspend"))
>  			suspend_state->disabled = true;
>  
> +		if (!of_property_read_u32(suspend_np,
> +					"regulator-suspend-microvolt", &pval))
> +			suspend_state->uV = pval;
> +
>  		of_node_put(suspend_np);
>  		suspend_state = NULL;
>  		suspend_np = NULL;
> 

Looks good to me.

Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
