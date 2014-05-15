Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaEOTd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 15:33:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60760 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaEOTd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 15:33:57 -0400
Message-ID: <5375169F.3060809@wwwdotorg.org>
Date: Thu, 15 May 2014 13:33:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [RFC PATCH 00/10] Tegra XHCI support
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1400113986-339-1-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 06:32 PM, Andrew Bresticker wrote:
> This is a first pass at the host and PHY drivers necessary for USB3.0
> support on Tegra114 and Tegra124.  The Tegra XHCI host controller requires
> external firmware [1] which must be loaded before using any USB ports owned
> by the controller.  The XUSB PHY driver handles mapping and enabling of
> the UTMI, HSIC, and SuperSpeed pads to the XHCI controller.
> 
> Tested on a Venice2 with a variety of USB2.0 and USB3.0 memory sticks
> and ethernet dongles.  
> 
> Notes:
>  - I've included support for Tegra114, but since I don't have Tegra114-based
>    hardware, it is completely untested.
>  - The PCIe and SATA PHYs also are programmed using the XUSB_PADCTL space
>    as well.  At least some of the code can be re-used, specifically with
>    respect to lane programming.  I believe Thierry is working on the PCIe
>    parts of this.

If I understand the HW correctly, there's a separate "pad control" HW
block that provides routing/sharing of signals from USB2(?), USB3, SATA,
and PCIe to the pads.

I believe Thierry is working on exposing this block as a pinctrl driver,
or at least something that the other drivers can call into in order to
configure that block. It'd be good if you can co-ordinate with him to
rebase this driver on top of that, rather than (I assume; haven't read
the code yet...) directly manipulating the padctrl registers inside each
of the different drivers. Co-ordinating that could turn out to be
problematic, and presumably if each driver does its own thing, we end up
duplicating defines, code, and DT bindings for configuring the padctrl HW.
