Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162652AbaDCIdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:33:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35969 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162539AbaDCIdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:33:05 -0400
Message-ID: <1396513926.5057.12.camel@weser.hi.pengutronix.de>
Subject: Re: [RESEND: RFC PATCH 3/3] pcie: keystone: add pcie driver based
 on designware core driver
From: Lucas Stach <l.stach@pengutronix.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, xobs@kosagi.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Zhu <r65037@freescale.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Mohit Kumar <mohit.kumar@st.com>, Jingoo Han <jg1.han@samsung.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Shawn Guo <shawn.guo@linaro.org>
Date: Thu, 03 Apr 2014 10:32:06 +0200
In-Reply-To: <533C460D.1030608@ti.com>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
	 <1395707726-20437-4-git-send-email-m-karicheri2@ti.com>
	 <235376049.yyfljDtinu@wuerfel> <533C460D.1030608@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 02.04.2014, 13:17 -0400 schrieb Murali Karicheri:
> Arnd,
> 
> Thanks for reviewing the RFC patch. Please see below my response.
> 
> On 3/25/2014 3:44 AM, Arnd Bergmann wrote:
> > On Monday 24 March 2014 20:35:26 Murali Karicheri wrote:
[...]
> 
> >> +	ks_pcie->clk = devm_clk_get(&pdev->dev, "pcie");
> >> +	if (IS_ERR(ks_pcie->clk)) {
> >> +		dev_err(&pdev->dev, "Failed to get pcie rc clock\n");
> >> +		return PTR_ERR(ks_pcie->clk);
> >> +	}
> >> +	ret = clk_prepare_enable(ks_pcie->clk);
> >> +	if (ret)
> >> +		return ret;
> > Could you move the clock handling into the generic dw-pcie code?
> 
> Could be. But currently only pci-exynos.c is using a clock name 
> "pcie".pci-imx6.c uses pcie_axi" and
> will have to be fixed so that we can move this code to the generic 
> dw-pcie code.  Sean Cross is the
> author for pci-imx6.c.
> 
> Sean,
> 
> Is "pcie_axi" is the pcie hw clock? If so, can you rename this to "pcie" 
> so that  my patch can move the
> clock handling code to pcie designware code?
> 
My series "i.MX6 PCIe binding change and MSI support" already changes
the clock name. So we could consolidate the clock handling once this is
in. Only difference is that the i.MX6 needs an additional PHY clock.

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

