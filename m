Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaDYOTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:19:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47679 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477AbaDYOSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:18:54 -0400
Date: Fri, 25 Apr 2014 16:18:49 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 03/18] usb: host: xhci-plat: Add support for the
 Armada 38x
Message-ID: <20140425161849.5616821e@skate>
In-Reply-To: <1398434836-18908-4-git-send-email-gregory.clement@free-electrons.com>
References: <1398434836-18908-1-git-send-email-gregory.clement@free-electrons.com>
	<1398434836-18908-4-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Fri, 25 Apr 2014 16:07:01 +0200, Gregory CLEMENT wrote:

> +#define USB3_MAX_WINDOWS	4
> +#define USB3_WIN_CTRL(w)	(0x0 + ((w) * 8))
> +#define USB3_WIN_BASE(w)	(0x4 + ((w) * 8))
> +
> +static void __init mv_usb3_conf_mbus_windows(void __iomem *base,
> +			const struct mbus_dram_target_info *dram)

That's a nitpick, but the name of this function looks like it was
copy/pasted from the Marvell LSP, and isn't very consistent with the
other function name. What about:

	xhci_mvebu_mbus_config()

instead, or something like that?

> +int xhci_mvebu_mbus_init_quirk(struct platform_device *pdev)

I believe this should give you a warning about section mismatch: you
have a non-init function calling an __init function, no?

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
