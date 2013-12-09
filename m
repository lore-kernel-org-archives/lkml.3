Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933627Ab3LIMvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:51:51 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17803 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab3LIMvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:51:48 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-f7-52a5bce16e4d
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH 1/4 v10] thermal: samsung: replace inten_ bit fields with
 intclr_
Date: Mon, 09 Dec 2013 13:51:35 +0100
Message-id: <4489646.QoKFUWLh9W@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1384866259-15983-1-git-send-email-ch.naveen@samsung.com>
References: <1384238168-24561-1-git-send-email-ch.naveen@samsung.com>
 <1384866259-15983-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xy7oP9ywNMphx29ii4WqIxcYZ61kt
	7j4/zGjx8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjc+Dx
	2DnrLrvH4j0vmTz6tqxi9Dh+YzuTx+dNcgGsUVw2Kak5mWWpRfp2CVwZm9c4FlzlrTjc85mp
	gXEydxcjJ4eEgInEsmmv2SBsMYkL99YD2VwcQgJLGSUOnLsA5XQxSVw6ORGsik1ATeJzwyMw
	WwSo+/irM+wgRcwCS5kk5i9bxAySEBYIl7j28A0riM0ioCoxa/1LsDivgKbEk02nwGx+AXWJ
	d9ueMoHYogJuEi/2bWEHsTmB7HkvbjBCbG5klHg0s5kNollQ4sfkeywgNrOAvMS+/VNZIWwt
	ifU7jzNNYBSchaRsFpKyWUjKFjAyr2IUTS1NLihOSs811CtOzC0uzUvXS87P3cQIiZcvOxgX
	H7M6xCjAwajEw7uCdWmQEGtiWXFl7iFGCQ5mJRFesV1AId6UxMqq1KL8+KLSnNTiQ4xMHJxS
	DYwW/W/41ogJ9ne82e8Ur3K+e49KkrhAtFbnfkfu2fkr1m8xnLrl4Od36vr+P/gPqvIKTSvV
	WXn0ljRLi3hD3We5Pxcyqt3vrXnpcv5gTkx7n+z6v9/m5EpMvBrYM8MqOS3V2lzn+58ZzOej
	52RLbpI4+ePCNlHt8tTzq7a/5gxkPK5mpvPvR5ASS3FGoqEWc1FxIgDYLpvIdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Tuesday 19 of November 2013 18:34:19 Naveen Krishna Chatradhi wrote:
> This patch replaces the inten_rise_shift/mask and inten_fall_shift/mask
> with intclr_rise_shift/mask and intclr_fall_shift/mask respectively.
> Currently, inten_rise_shift/mask and inten_fall_shift/mask bits are only used
> to configure intclr related registers.
> 
> Description of H/W:
> The offset for the bits in the CLEAR register are not consistent across TMU
> modules in Exynso5250, 5420 and 5440.
> 
> On Exynos5250, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT registers and at an offset of
> 12 in INTCLEAR register.
> 
> On Exynos5420, the FALL interrupt related en, status and clear bits are
> available at an offset of
> 16 in INTEN, INTSTAT and INTCLEAR registers.
> 
> On Exynos5440,
> the FALL_IRQEN bits are at an offset of 4
> and the RISE_IRQEN bits are at an offset of 0
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> Changes since v9:
> Just respinning
> 
> Changes since v8:
> 1. Modified the patch description,
> 2. replaces the inten_rise/fall_shift/mask with intclr_rise/fall_shift/mask
> 
>  drivers/thermal/samsung/exynos_tmu.c      |    6 +++---
>  drivers/thermal/samsung/exynos_tmu.h      |   16 ++++++++--------
>  drivers/thermal/samsung/exynos_tmu_data.c |   18 +++++++++---------
>  drivers/thermal/samsung/exynos_tmu_data.h |    4 ++--
>  4 files changed, 22 insertions(+), 22 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

