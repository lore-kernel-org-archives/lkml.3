Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaGGOQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:16:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51100 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753276AbaGGOQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:16:10 -0400
Date: Mon, 7 Jul 2014 10:16:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] USB: EHCI: tegra: Fix probe order issue leading
 to broken USB
In-Reply-To: <1404436179-10745-4-git-send-email-ttynkkynen@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1407071015470.871-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2014, Tuomas Tynkkynen wrote:

> The Tegra USB complex has a particularly annoying misdesign: some of the
> UTMI pad configuration registers are global for all the 3 USB controllers
> on the chip, but those registers are located in the first controller's
> register space and will be cleared when the reset to the first
> controller is asserted. Currently, this means that if the 1st controller
> were to finish probing after the 2nd or 3rd controller, USB would not
> work at all.
> 
> Fix this situation by always resetting the 1st controller before doing
> any other setup to any of the controllers, and then never ever reset the
> first controller again. As the UTMI registers are related to the PHY,
> the PHY driver should probably reset the Tegra controllers instead,
> but since old device trees only have reset phandles in the EHCI nodes,
> do it here, which means a bit of device tree groveling. Those old DTs
> also won't get the reset fix from this commit, so we'll dev_warn() them,
> but the driver will still keep probing successfully.
> 
> Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
> ---
> v2 changes: assume we can find the usb1 reset from the PHY DT node,
>             don't fail if it's not found but just issue a warning
>  drivers/usb/host/ehci-tegra.c |   62 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 59 insertions(+), 3 deletions(-)

Acked-by: Alan Stern <stern@rowland.harvard.edu>

