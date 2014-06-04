Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaFDLF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:05:29 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:55364 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbaFDLF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:05:27 -0400
Date: Wed, 4 Jun 2014 12:05:18 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patrice.chotard@st.com, srinivas.kandagatla@gmail.com,
        chris@printf.net, ulf.hansson@linaro.org, kernel@stlinux.com,
        lee.jones@linaro.org, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/8] mmc: sdhci-st: Intial support for ST SDHCI controller
Message-ID: <20140604110518.GA1722@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-2-git-send-email-peter.griffin@linaro.org>
 <537E1AB8.9000909@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537E1AB8.9000909@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thanks fo reviewing, see my comments below: -

> >+struct st_mmc_platform_data {
> >+	struct  reset_control	*rstc;
> >+};
> Since it uses the generic reset framework, could we imagine moving
> the reset to the sdhci_pltfm_host struct?
> Doing this, we could get rid of st_mmc_platform_data.

Yes I agree, I will send some RFC patches which moves the reset controller
stuff into the generic code.

For v2 of this series I've removed the reset code, as stih416 doesn't have
seperate reset line each controller, so it will mainly be 
useful for stih407 SoC, which needs additional patches on top of this 
set.

> >+	switch (width) {
> >+	case MMC_BUS_WIDTH_8:
> >+		ctrl |= SDHCI_CTRL_8BITBUS;
> >+		ctrl &= ~SDHCI_CTRL_4BITBUS;
> >+		break;
> >+	case MMC_BUS_WIDTH_4:
> >+		ctrl |= SDHCI_CTRL_4BITBUS;
> >+		ctrl &= ~SDHCI_CTRL_8BITBUS;
> >+		break;
> >+	default:
> >+		ctrl &= ~(SDHCI_CTRL_8BITBUS | SDHCI_CTRL_4BITBUS);
> >+		break;
> You can remove the break here.

Ok, removed in v2

> >+	switch (reg) {
> >+	case SDHCI_CAPABILITIES:
> >+		ret = readl(host->ioaddr + reg);
> >+		/* Support 3.3V and 1.8V */
> >+		ret &= ~SDHCI_CAN_VDD_300;
> >+		break;
> >+	default:
> >+		ret = readl(host->ioaddr + reg);
> 
> Could we use readl_relaxed?

Yes, I've updated to use readl_relaxed in v2

> >+	dev_dbg(&pdev->dev, "SDHCI ST platform driver\n");
> You can remove this I think.

Removed in v2

> >+		host_version, ((host_version & SDHCI_VENDOR_VER_MASK) >>
> >+			       SDHCI_VENDOR_VER_SHIFT));
> Maybe you could change to dev_info here. It might be interresting to
> always have IP version.

Changed to dev_info in v2

Regards,

Peter.
