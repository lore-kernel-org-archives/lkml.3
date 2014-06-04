Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340AbaFDIhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:37:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47582 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaFDIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:37:31 -0400
Date: Wed, 4 Jun 2014 09:37:27 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org, devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-mmc@vger.kernel.org, Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        lee.jones@linaro.org
Subject: Re: [PATCH 1/8] mmc: sdhci-st: Intial support for ST SDHCI controller
Message-ID: <20140604083727.GA23469@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
 <537EE84C.2020607@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537EE84C.2020607@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srini,

Thanks for reviewing, see my comments below: -

On Fri, 23 May 2014, Srinivas Kandagatla wrote:

> >+struct st_mmc_platform_data {
> >+	struct  reset_control	*rstc;
> >+};
> 
> st_mmc_platform_data name is bit missleading as this data is not
> part of platform data. Probably you could rename it to struct
> sdhci_st_data.

I've now removed this reset controller code for v2, as based on Maxime's feedback
I think this would be better off going in the generic code, so all 
platforms could benefit if they have a reset controller implementation.

I plan to send some RFC patches which implement this seperately to this series.

> >+	pltfm_host->priv = pdata;
> >+
> >+	platform_set_drvdata(pdev, host);
> 
> Why not platform_set_drvdata(pdev, priv_host);
> As you are not using sdhci_host directly, this will reduced few
> indirections in the driver.

Your right, and I was going to change this, but with the re-think on the reset
controller code above I will now need sdhci_host so would prefer to leave it as
is for now.

> >+err_out:
> >+	clk_disable_unprepare(clk);
> >+	sdhci_pltfm_free(pdev);
> >+
> IP could be left out of reset in this path.

Good spot, I'll remember this when I add the reset code
back in :-)

> 
> replace:
> [...
> >+static SIMPLE_DEV_PM_OPS(sdhci_st_pmops, sdhci_st_suspend, sdhci_st_resume);
> >+#define SDHCI_ST_PMOPS (&sdhci_st_pmops)
> >+#else
> >+#define SDHCI_ST_PMOPS NULL
> >+#endif
> ...]
> 
> with :
> 
> #endif
> 
> static SIMPLE_DEV_PM_OPS(sdhci_st_pmops, sdhci_st_suspend, sdhci_st_resume);

Fixed in v2

regards,

Peter.
