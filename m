Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaEIJnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:43:45 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46564 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbaEIJnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:43:43 -0400
Date: Fri, 9 May 2014 11:43:30 +0200
From: Pavel Machek <pavel@denx.de>
To: Marek Vasut <marex@denx.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, rogerq@ti.com, balajitk@ti.com,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for
 pcie-dra7xx controller
Message-ID: <20140509094330.GB4877@xo-6d-61-c0.localdomain>
References: <1399383244-14556-1-git-send-email-kishon@ti.com>
 <1399383244-14556-6-git-send-email-kishon@ti.com>
 <201405061544.28738.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201405061544.28738.marex@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +	writel(value, base + offset);
> > +}
> > +
> > +static int dra7xx_pcie_link_up(struct pcie_port *pp)
> > +{
> > +	struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
> > +	u32 reg = dra7xx_pcie_readl(dra7xx->base, PCIECTRL_DRA7XX_CONF_PHY_CS);
> > +
> > +	if (reg & LINK_UP)
> > +		return true;
> > +	return false;
> 
> return reg & LINK_UP;

Function int returning true. I'd change the prototype and would
return !!(reg & ...);

									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
