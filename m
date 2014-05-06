Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520AbaEFLfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:35:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:63399 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbaEFLfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:35:13 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-25-5368c8ef2f3e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        devicetree@vger.kernel.org, Nadav Haklai <nadavh@marvell.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the Armada
 38x
Date: Tue, 06 May 2014 13:34:46 +0200
Message-id: <1584794.IM1uiSkBdk@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1399335255-589-7-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-7-git-send-email-gregory.clement@free-electrons.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQd33JzKCDWZukbe40H+J2eL83UPM
	Fgfv11vMP3KO1eL0qQWsFgf+7GC0aF68ns1iU9tbRovGJZdZLDY9vsZqcXnXHDaLRctamS2a
	N01htZjU3s5u0br3CLvF+5+OFstO/WS0ePqgiclByOPJpouMHjtn3WX3WLznJZPHplWdbB4N
	B86zeNy5tofNY//cNewem5fUe+zc8ZnJY/LCi8wex29sZ/L4vEkugCeKyyYlNSezLLVI3y6B
	K+PknA0sBW08FUdnHWFrYHzI2cXIySEhYCLR93AzI4QtJnHh3nq2LkYuDiGB6YwSbz+tZ4Rw
	WpgkZk49wAJSxSZgJTGxfRVYh4iAhsSUrsfsIDazwHZWiW3zEkFsYYEQib7/k1hBbBYBVYmG
	W3eYQGxeAU2JH+tmsoHYogKeEju2rwSzOQWCJZ4vX8wMsWwmo8T1nh5miAZBiR+T77FALJCX
	2Ld/KiuErSWxfudxpgmMArOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMFx+UxqB+PKBotDjAIcjEo8vCdWpgcLsSaWFVfmHmKU4GBWEuFVXJkRLMSbklhZlVqUH19U
	mpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoHRV6dEN2GZhMWKF4U9RQ6X93WY
	th7eHLKe6fKfuw68vUndluF1tfpqDasuxB0TWRogI9m2pfz2fpV/NoeVNu9Z82HW3AnH3r6s
	rpfVYouee7701ppzfK+yy2rMHNwYV6UyzHs+q1HxK1OsZNyFv+d3/czmXpjVIMT8W8HvhYhc
	7sYXbzKuiwQosRRnJBpqMRcVJwIA/6Ew0scCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, May 06, 2014 02:14:01 AM Gregory CLEMENT wrote:
> For the Armada 38x SoCs which come with an xhci controller, specific
> initialization must be done during probe related to the MBus windows
> configuration. This patch adds the support of this quirk.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/usb/host/Kconfig      |  7 +++++
>  drivers/usb/host/Makefile     |  1 +
>  drivers/usb/host/xhci-mvebu.c | 71 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/usb/host/xhci-mvebu.h | 21 +++++++++++++
>  drivers/usb/host/xhci-plat.c  |  6 ++++
>  5 files changed, 106 insertions(+)
>  create mode 100644 drivers/usb/host/xhci-mvebu.c
>  create mode 100644 drivers/usb/host/xhci-mvebu.h
> 
> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
> index 3d9e54062d62..e70943fac4a1 100644
> --- a/drivers/usb/host/Kconfig
> +++ b/drivers/usb/host/Kconfig
> @@ -29,6 +29,13 @@ if USB_XHCI_HCD
>  config USB_XHCI_PLATFORM
>  	tristate
>  
> +config USB_XHCI_MVEBU
> +	tristate "xHCI support for Marvell Armada 38x"

Please limit this driver to mvebu arch and compile testing, i.e.

	depends on ARCH_MVEBU || COMPILE_TEST

> +	select USB_XHCI_PLATFORM
> +	---help---
> +	  Say 'Y' to enable the support for the xHCI host controller
> +	  found in Marvell Armada 38x ARM SOCs.
> +
>  endif # USB_XHCI_HCD
>  
>  config USB_EHCI_HCD

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

