Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3DWRRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:17:07 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:63153 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab3DWRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:17:04 -0400
Date: Tue, 23 Apr 2013 10:17:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Stephen Warren <swarren@nvidia.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 18/21] usb: phy: tegra: don't call into tegra-ehci
 directly
Message-ID: <20130423171701.GA31397@kroah.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <1366734653-488286-19-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366734653-488286-19-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 06:30:50PM +0200, Arnd Bergmann wrote:
> Both phy-tegra-usb.c and ehci-tegra.c export symbols used by the other one,
> which does not work if one of them or both are loadable modules, resulting
> in an error like:
> 
> drivers/built-in.o: In function `utmi_phy_clk_disable':
> drivers/usb/phy/phy-tegra-usb.c:302: undefined reference to `tegra_ehci_set_phcd'
> drivers/built-in.o: In function `utmi_phy_clk_enable':
> drivers/usb/phy/phy-tegra-usb.c:324: undefined reference to `tegra_ehci_set_phcd'
> drivers/built-in.o: In function `utmi_phy_power_on':
> drivers/usb/phy/phy-tegra-usb.c:447: undefined reference to `tegra_ehci_set_pts'
> 
> This turns the interface into a one-way dependency by letting the tegra ehci
> driver pass two function pointers for callbacks that need to be called by
> the phy driver.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/host/ehci-tegra.c     | 10 +++++-----
>  drivers/usb/phy/tegra_usb_phy.c   | 13 +++++++++----
>  include/linux/usb/tegra_usb_phy.h | 10 +++++-----
>  3 files changed, 19 insertions(+), 14 deletions(-)

Not all of these files are in my usb-next tree, so I can't take this
patch, sorry.

greg k-h
