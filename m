Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbaIILxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:53:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12207 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaIILw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:52:59 -0400
X-AuditID: cbfee61a-f79e46d00000134f-24-540eea183cd8
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Griffin <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org,
        kishon@ti.com, srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/4] phy: phy-stih407-usb: Add usb picoPHY driver found
 on stih407 SoC family
Date: Tue, 09 Sep 2014 13:52:54 +0200
Message-id: <1706244.K6iQdujHby@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1410253218-18318-2-git-send-email-peter.griffin@linaro.org>
References: <1410253218-18318-1-git-send-email-peter.griffin@linaro.org>
 <1410253218-18318-2-git-send-email-peter.griffin@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9jAV3JV3whBiu6GC3mHznHanHhaQ+b
	xf2vRxktNj2+xmpxedccNotHpxezWcw5cZXR4v/rrYwWG2b8Y7Fo+xbnwOWxc9Zddo871/aw
	eWxeUu/x9MdeZo/jN7YzeXzeJBfAFsVlk5Kak1mWWqRvl8CVcf3zAcaCL9wV82+uZWlgPMzZ
	xcjJISFgIjF7zwtmCFtM4sK99WxdjFwcQgKLGCUWvt7ECOG0MEn8+NLGAlLFJmAlMbF9FSOI
	LSKgITGl6zE7SBGzwA9GiQWtk9hAEsICaRKtJxeDFbEIqEpsWnMSrJlXQFPi49spYDWiAp4S
	O7avBLM5geynq79DbWtnlHi6dAErRIOgxI/J98CamQXkJfbtn8oKYWtJrN95nGkCo8AsJGWz
	kJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwPDyT2sG4ssHiEKMAB6MSD29G
	MF+IEGtiWXFl7iFGCQ5mJRFe6xdAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tS
	s1NTC1KLYLJMHJxSDYycYVKrc8vlX9vs/JWhpa11oc3/+duIuhMPN0zOb0i3a/60YsNrjR6b
	hd/2/dx1YtaOy4FHA3/c4L7k9LpI36rILdbD0+pOTLtaRFr000e79jtmCWrwJX2JVRb56BB2
	a6Pmxu8/uBfdX7jcWmaLjJLGItZkwbpclQUMax5y5Bnb8HltmbfzhoUSS3FGoqEWc1FxIgDC
	avJsgwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, September 09, 2014 10:00:15 AM Peter Griffin wrote:
> This is the generic phy driver for the picoPHY ports used by the
> USB2 and USB3 Host controllers when controlling usb2/1.1 devices. It
> is found on STiH407 SoC family from STMicroelectronics.
> 
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/phy/Kconfig           |   8 ++
>  drivers/phy/Makefile          |   2 +
>  drivers/phy/phy-stih407-usb.c | 185 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 195 insertions(+)
>  create mode 100644 drivers/phy/phy-stih407-usb.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 0dd7427..58018f7 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -230,4 +230,12 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config PHY_STIH407_USB
> +	tristate "STMicroelectronics USB2 picoPHY driver for STiH407 family"
> +	depends on ARCH_STI
> +	depends on GENERIC_PHY

I believe that this should use

	select GENERIC_PHY

instead (just like all other PHY drivers except PHY_MIPHY365X which
also should be fixed to use select).

> +	help
> +	  Enable this support to enable the picoPHY device used by USB2
> +	  and USB3 controllers on STMicroelectronics STiH407 SoC families.
> +

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

