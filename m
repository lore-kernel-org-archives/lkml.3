Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbaEFLhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:37:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39760 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaEFLhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:37:11 -0400
X-AuditID: cbfee61b-b7f766d00000646c-1b-5368c965d74d
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
Subject: Re: [PATCH v3 17/20] phy: Add support for USB cluster on the Armada
 375 SoC
Date: Tue, 06 May 2014 13:37:04 +0200
Message-id: <2511421.HV0z8e3QV0@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1399335255-589-18-git-send-email-gregory.clement@free-electrons.com>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com>
 <1399335255-589-18-git-send-email-gregory.clement@free-electrons.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jAd3UkxnBBht/6Vpc6L/EbHH+7iFm
	i4P36y3mHznHanH61AJWiwN/djBaNC9ez2axqe0to0XjksssFpseX2O1uLxrDpvFomWtzBbN
	m6awWkxqb2e3aN17hN3i/U9Hi2WnfjJaPH3QxOQg5PFk00VGj52z7rJ7LN7zkslj06pONo+G
	A+dZPO5c28PmsX/uGnaPzUvqPXbu+MzkMXnhRWaP4ze2M3l83iQXwBPFZZOSmpNZllqkb5fA
	lXHv8kPGgoXcFUsfv2VrYPzJ0cXIySEhYCJxZO0LFghbTOLCvfVsXYxcHEICixglFpy6wg7h
	tDBJPP97lBGkik3ASmJi+yowW0RAQ2JK12N2EJtZYDurxLZ5iV2MHBzCAmESU3fqgYRZBFQl
	bq39zwRi8wpoSuy+vh1smaiAp8SO7SvZQGxOgRCJd7POsULsmsUo8WrWU3aIBkGJH5PvsUDM
	l5fYt38qK4StJbF+53GmCYxA1Qhls5CUzUJStoCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcFQ+k97BuKrB4hCjAAejEg/viZXpwUKsiWXFlbmHGCU4mJVEeBVXZgQL8aYkVlalFuXH
	F5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYEy8LrPo3uE3NfLflNxqBK4/
	P+20yrExI2j5bq08P7Hk6PWCj1Y3Ot1Xc9N1YMuJsp6zLGFB3B7Hn1/vf3tUa82WXrwsms1k
	482zyXJSk89u+DUn6tD1DWZZH44bxy5g+1xWlecuIGwiZSWQNfFMQJxN4+IX8vpTDB6dt5z0
	9f8NVbOMXRVp95VYijMSDbWYi4oTAbpWrJLGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, May 06, 2014 02:14:12 AM Gregory CLEMENT wrote:
> The Armada 375 SoC comes with an USB2 host and device controller and
> an USB3 controller. The USB cluster control register allows to manage
> common features of both USB controllers. It uses the generic PHY
> framework
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/phy/Kconfig              |   5 ++
>  drivers/phy/Makefile             |   1 +
>  drivers/phy/phy-armada375-usb2.c | 154 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 160 insertions(+)
>  create mode 100644 drivers/phy/phy-armada375-usb2.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 3bb05f17b9b4..cdf3e2c24e3a 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -15,6 +15,11 @@ config GENERIC_PHY
>  	  phy users can obtain reference to the PHY. All the users of this
>  	  framework should select this config.
>  
> +config ARMADA375_USBCLUSTER_PHY
> +	def_bool y
> +	depends on OF

Please limit this driver to Armada 375 or compile testing, i.e. add additional

	depends on (ARCH_MVEBU && MACH_ARMADA_375) || COMPILE_TEST

> +	select GENERIC_PHY
> +
>  config PHY_EXYNOS_MIPI_VIDEO
>  	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
>  	depends on HAS_IOMEM

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

