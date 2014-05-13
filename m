Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbaEMOxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:53:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42603 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752916AbaEMOxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:53:36 -0400
Date: Tue, 13 May 2014 10:53:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Maxime Ripard <maxime.ripard@free-electrons.com>
cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, <kishon@ti.com>,
        <hdegoede@redhat.com>, Boris Brezillon <boris@free-electrons.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kevin.z.m.zh@gmail.com>,
        <sunny@allwinnertech.com>, <shuge@allwinnertech.com>,
        <zhuzhenhua@allwinnertech.com>, <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH v4 0/8] Add Allwinner A31 USB support
In-Reply-To: <1399969145-11642-1-git-send-email-maxime.ripard@free-electrons.com>
Message-ID: <Pine.LNX.4.44L0.1405131053050.1098-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014, Maxime Ripard wrote:

> Hi everyone,
> 
> This patchset adds support for the USB controllers found in the
> Allwinner A31.
> 
> While the design is similar to the earlier Allwinner SoCs that are
> already supported, a few details here and there change, like the fact
> that the PHYs now have one clock per phy, while it used to be only one
> for all the PHYs.
> 
> Thanks,
> Maxime
> 
> Changes from v3:
>   - Asserted back the ECHI/OHCI in reset if probe fails
>   - Drop of the redundant NULL assignent for the PMU in the PHY rework
> 
> Changes from v2:
>   - Fixed indentation and used the reset framework in all case and not
>     just in DT case
>   - Added a default value to the dedicated_clocks variable. Setting it
>     actually started triggering a gcc warning for no reason. Ended up
>     reworking a bit the code to avoid it.
> 
> Changes from v1:
>   - Moved the reset assertion/deassertion to probe/remove
>   - Moved the dedicated_clocks to the probe function instead of the
>     private structure since it was the only user
> 
> Boris BREZILLON (2):
>   usb: ehci-platform: add optional reset controller retrieval
>   ARM: sunxi: dt: add APP4-EVB1 board support
> 
> Maxime Ripard (6):
>   clk: sunxi: Implement A31 USB clock
>   ARM: sun6i: Add the USB clocks to the DTSI
>   phy: sunxi: Rework phy initialization
>   phy: usb: sunxi: Introduce Allwinner A31 USB PHY support
>   usb: ohci-platform: Enable optional use of reset controller
>   ARM: sun6i: dt: Add support for the USB controllers

For the changes to ehci-platform and ohci-platform:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

