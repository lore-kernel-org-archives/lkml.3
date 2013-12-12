Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3LLL1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:27:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54977 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3LLL1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:27:44 -0500
Date: Thu, 12 Dec 2013 11:27:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Porter <mporter@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Kamil Debski <k.debski@samsung.com>,
        Linaro Patches <patches@linaro.org>, Tomasz Figa <t.figa@samsung.com>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/9] phy: add
	phy_get_bus_width()/phy_set_bus_width() calls
Message-ID: <20131212112715.GK4360@n2100.arm.linux.org.uk>
References: <1386847117-21240-1-git-send-email-mporter@linaro.org> <1386847117-21240-2-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386847117-21240-2-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 06:18:29AM -0500, Matt Porter wrote:
>  /**
> + * struct phy_attrs - represents phy attributes
> + * @bus_width: Data path width implemented by PHY
> + */
> +struct phy_attrs {
> +	u32			bus_width;

Why u32?

>  int phy_power_off(struct phy *phy);
> +static inline u32 phy_get_bus_width(struct phy *phy)
> +{
> +	return phy->attrs.bus_width;
...
>  
> +static inline u32 phy_get_bus_width(struct phy *phy)
> +{
> +	return -ENOSYS;

Why u32, especially as you're returning a negative number here.

If the bus width is a small integer (I'm assuming you don't have up to
2^30 bus signals) then what's wrong with it being an 'int' ?
