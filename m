Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3FXT11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:27:27 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22841 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3FXT1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:27:25 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-bc-51c89d9a4ac3
Message-id: <51C89D98.1070806@samsung.com>
Date: Mon, 24 Jun 2013 21:27:20 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>, grant.likely@linaro.org,
        tony@atomide.com, arnd@arndb.de, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        rob.herring@calxeda.com, rob@landley.net, b-cousson@ti.com,
        linux@arm.linux.org.uk, benoit.cousson@linaro.org, mchehab@redhat.com,
        cesarb@cesarb.net, davem@davemloft.net, rnayak@ti.com,
        shawn.guo@linaro.org, santosh.shilimkar@ti.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        nsekhar@ti.com
Subject: Re: [PATCH v7 0/9] Generic PHY Framework
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <51BEE203.6090103@samsung.com> <20130618094942.GY5461@arwen.pp.htv.fi>
In-reply-to: <20130618094942.GY5461@arwen.pp.htv.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t/xa7qz5p4INGjpVrGYs34Nm8XfScfY
	Lb7d3sRscfB+vcXMTzfZLGZdC7KYc76FxeLA7IesFgf+7GC0aF68ns3iwtMeNotNj6+xWixs
	W8JicXnXHDaL2Uv6WSwWLWtltrh9mddiz9HD7Bb7ezcwWTzr38NocXjFASaLdS+ns1i87lvD
	bPF03RJmixvTW1gt9l/xcpDyaGnuYfP4/WsSo8e3r5NYPBZ8vsLuceT2DGaPLStvMnm8Wj2T
	1ePOtT1sHidm/Gbx2D93DbvH5iX1HudnLGT06G1+x+bxft9VNo/jN7YzeXzeJBcgEMVlk5Ka
	k1mWWqRvl8CVsWnGfLaCzewVuybcZ2tg/MvaxcjJISFgIrFl2llGCFtM4sK99WxdjFwcQgJL
	GSUenHrNCOF8YpSYP+06G0gVr4CWRNerLWA2i4CqxM6pk5hBbDYBQ4neo31gk0QFAiQWLznH
	DlEvKPFj8j0WEFtEQEBi/YtLYHFmgW8sEusP64PYwkC9Ny58YIJY1soo8bDpNth5nEDnbZt5
	mBmiQUdif+s0NghbXmLzmrfMExgFZiHZMQtJ2SwkZQsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al
	6yXn525ihKSCLzsYFx+zOsQowMGoxMP7Me5EoBBrYllxZe4hRgkOZiUR3lARoBBvSmJlVWpR
	fnxRaU5q8SFGJg5OqQbGDW8f+SXP0OtXXrNu4xWxwLX/OfasPF+zQEDL5FOSx6WmpdaXt79Z
	8zay4t6KN0bnozk43dx3ey/pnBa82XjTjh9mP3c6O957e+Kv55+v8m36s5SalVq8tTXe6Bls
	TzoetKhwzfJze0Qsv0je21dw3PZS2P5/4i6NktOLkz3WnfdT3tuyzTZfRYmlOCPRUIu5qDgR
	AEYmcSPjAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/18/2013 11:49 AM, Felipe Balbi wrote:
> On Mon, Jun 17, 2013 at 12:16:35PM +0200, Sylwester Nawrocki wrote:
>> I have already used this API for our MIPI CSI-2/DSIM DPHYs driver,
>> the RFC patch series can be found at [1].
>>
>> Thanks,
>> Sylwester
>>
>> [1] http://www.spinics.net/lists/arm-kernel/msg251666.html
> 
> one comment to that series:
> 
> let's make the phy names standardized, how about phy-exynos-video-mipi.c
> or phy-mipi-csi-dsim.c ?

Yes, I have been thinking about that, wasn't sure exactly what pattern to
chose. I would make it phy-exynos-mipi-video.c, phy-exynos-dsim-csis.c feels
a bit odd. phy-mipi-csis-dsim.c might be to generic as MIPI CSIS stands for
MIPI CSI Slave and MIPI DSIM - MIPI DSI Master. And there might be (actually
are) IP blocks in an SoC that use the other MIPI Aliance standards.
For the HDMI PHY I guess just phy-exynos-hdmi.c could be used.

Thanks,
Sylwester

