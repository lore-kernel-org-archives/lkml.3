Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab3LSLeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:34:24 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53966 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3LSLeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:34:21 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-67-52b2d9bb5898
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH v12 3/4] thermal: samsung: Add TMU support for Exynos5420
 SoCs
Date: Thu, 19 Dec 2013 12:34:03 +0100
Message-id: <3663519.7JfYNffMTG@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1387433191-7861-1-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
 <1387433191-7861-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xy7q7b24KMpg4X9Oi4WqIxcYZ61kt
	7j4/zGjx8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjc+Dx
	2DnrLrvH4j0vmTz6tqxi9Dh+YzuTx+dNcgGsUVw2Kak5mWWpRfp2CVwZTU8/sxdc5604dOIJ
	SwNjF3cXIweHhICJxMKvjl2MnECmmMSFe+vZuhi5OIQEljJK3P3bywThdDFJ3HrXzgpSxSag
	JvG54REbiC0C1Hz81Rl2kCJmgaVMEvOXLWIGSQgLhEh0HVgD1sAioCpxs2sTWJxXQFPi9se1
	TCA2v4C6xLttT8FsUQE3iRf7trCD2JwCrhLzlk4AiwsJ1Euc2/eJBaJXUOLH5HtgNrOAvMS+
	/VNZIWwtifU7jzNNYBSchaRsFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQI
	iZavOxiXHrM6xCjAwajEw7vi5cYgIdbEsuLK3EOMEhzMSiK8k65vChLiTUmsrEotyo8vKs1J
	LT7EyMTBKdXAqL8u2jN/7RZOyzx9rpxZdilm3/5823rG6fP9XScuzZolxqy34+vhBakxWyas
	ff2oiSOMKdndpurUR9llyus2KR6w+KGon+A6y7YtamPf7UCzR37fL/Zqp19aXcq668OlvYKd
	Dv+VhD9G+u6vmvH22o1nxm9VYgIqjy54IrvLX3+x+7HzGueKbiixFGckGmoxFxUnAgClDiUx
	dAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 of December 2013 11:36:31 Naveen Krishna Chatradhi wrote:
> Exynos5420 has 5 TMU channels, the TRIMINFO register is
> misplaced for TMU channels 2, 3 and 4
> TRIMINFO at 0x1006c000 contains data for TMU channel 3
> TRIMINFO at 0x100a0000 contains data for TMU channel 4
> TRIMINFO at 0x10068000 contains data for TMU channel 2
> 
> This patch
> 1 Adds the neccessary register changes and arch information
>    to support Exynos5420 SoCs.
> 2. Handles the gate clock for misplaced TRIMINFO register
> 3. Updates the Documentation at
>    Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> Changes since v11:
> 1. Added description for clocks in the Documentation
> 2. corrected the clock name in clk_get() function as per description
> 
> Changes since v10:
> 1. using renamed compatible "samsung,exynos5420-tmu-ext-triminfo"
>    and passing same clock as triminfo_apbif clock for channel 2
> 2. removed the "exynos5420-tmu-triminfo-clk" compatible
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   45 ++++++++-
>  drivers/thermal/samsung/exynos_tmu.c               |   52 +++++++++-
>  drivers/thermal/samsung/exynos_tmu.h               |    1 +
>  drivers/thermal/samsung/exynos_tmu_data.c          |   99 ++++++++++++++++++++
>  drivers/thermal/samsung/exynos_tmu_data.h          |    8 ++
>  5 files changed, 200 insertions(+), 5 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

