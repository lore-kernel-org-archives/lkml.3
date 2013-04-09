Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935008Ab3DIPVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 11:21:41 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.16]:21708 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761860Ab3DIPVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 11:21:40 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-16.tower-29.messagelabs.com!1365520898!22775177!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <516431F9.8010302@digi.com>
Date: Tue, 9 Apr 2013 17:21:29 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: <linux-mmc@vger.kernel.org>, <kernel@pengutronix.de>, <cjb@laptop.org>,
        <aletes.xgr@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v2 2/2] mmc: mxs-mmc: add non-removable property
References: <1365166070-9370-1-git-send-email-mkl@pengutronix.de> <1365166070-9370-3-git-send-email-mkl@pengutronix.de> <51643053.7030302@digi.com>
In-Reply-To: <51643053.7030302@digi.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 05:14 PM, Hector Palacios wrote:
> @@ -95,7 +97,8 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
>          struct mxs_mmc_host *host = mmc_priv(mmc);
>          struct mxs_ssp *ssp = &host->ssp;
>
> -       return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
> +       return host->non_removable || host->broken_cd ||
> +              !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
>                   BM_SSP_STATUS_CARD_DETECT);
>   }

Sorry, I missed your original XOR here, when merging my changes:

@@ -95,7 +97,8 @@ static int mxs_mmc_get_cd(struct mmc_host *mmc)
         struct mxs_mmc_host *host = mmc_priv(mmc);
         struct mxs_ssp *ssp = &host->ssp;

-       return !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
+       return host->non_removable || host->broken_cd ||
+              !(readl(ssp->base + HW_SSP_STATUS(ssp)) &
+                BM_SSP_STATUS_CARD_DETECT) ^ host->cd_inverted;
  }

  static void mxs_mmc_reset(struct mxs_mmc_host *host)


Regards,
-- 
Héctor Palacios
