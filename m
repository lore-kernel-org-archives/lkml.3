Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292AbaLKNUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 08:20:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34783 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbaLKNUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 08:20:52 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f0-54899a32cf85
Message-id: <1418304046.29711.2.camel@AMDC1943>
Subject: Re: [PATCH] regulator: s2mps11: Fix dwmmc failure on Gear 2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Thu, 11 Dec 2014 14:20:46 +0100
In-reply-to: <20141211131305.GW11764@sirena.org.uk>
References: <1418301551-31678-1-git-send-email-k.kozlowski@samsung.com>
 <20141211131305.GW11764@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xq7pGszpDDJ48Z7OY+vAJm8W3Kx1M
	Fpd3zWGzuLjiC5PFgo2PGB1YPXbOusvusWlVJ5tH35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVw
	ZZyZ+I294CFnxb9Z4Q2M99m7GDk5JARMJI4/3cIIYYtJXLi3nq2LkYtDSGApo8TXFTOZIJzP
	jBLPl30B6+AV0Jc4u+s7M4gtLOAiMWvnXjCbTcBYYvPyJWwgtoiAssTV73tZQJqZBZoZJXoO
	/ARLsAioSpxvvg3WwAnU0Hj0ENhQIYECiT+9H8HOYBZQl5g0bxFQDQfQScoSjf1uEHsFJX5M
	vscCUSIvsXnNW+YJjAKzkHTMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh
	Yfx1B+PSY1aHGAU4GJV4eDPiO0OEWBPLiitzDzFKcDArifBaRQCFeFMSK6tSi/Lji0pzUosP
	MTJxcEo1MK5vcNj3c4uHSIrU7t45B/dffTfDcf/0n8vVfv/35xMQPN7CvnnTKWHerhRfa9GJ
	/pwMH5ZPk5SpOs5TuIaPsdZwHfNfsxyt9wHOB5Qa+SzDxYs+PbhSeTRqZ+KSwOIlihyTrqvu
	rfj95s6COWEVp3vC951Mnbz/QyzHhQO6gmW+R1dLFEwQU1FiKc5INNRiLipOBADIWhjnQQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-12-11 at 13:13 +0000, Mark Brown wrote:
> On Thu, Dec 11, 2014 at 01:39:11PM +0100, Krzysztof Kozlowski wrote:
> > Invalid buck4 configuration in S2MPS14 regulators caused boot failure on
> > Gear 2 (dwmmc_exynos):
> 
> What is invalid about the configuration and how is this change intended
> to fix it?

Wrong number was used for buck4 linear_min_sel. It should be
S2MPS14_BUCK4_START_SEL (0x40) instead of S2MPS14_BUCK1235_START_SEL
(0x20).

Issue is fixed by using proper number.

I'll resend the patch with extended description.

> 
> > [    3.569137] EXT4-fs (mmcblk0p15): mounted filesystem with ordered data mode. Opts: (null)
> > [    3.571716] VFS: Mounted root (ext4 filesystem) readonly on device 179:15.
> > [    3.580836] devtmpfs: mounted
> > [    3.582033] Freeing unused kernel memory: 284K (c05b4000 - c05fb000)
> > [    3.629842] mmcblk0: error -110 sending status command, retrying
> > [    3.630244] mmcblk0: error -110 sending status command, retrying
> 
> Please don't include large log sections in commit messages, edit them
> down to any relevant information.  They get very large and obscure the
> relevant content in the messages.

I'll trim it.

Best regards,
Krzysztof



