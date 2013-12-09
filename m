Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536Ab3LIMq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:46:27 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17220 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab3LIMqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:46:25 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-60-52a5bba02c13
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH 3/4 v10] thermal: samsung: Add TMU support for Exynos5420
 SoCs
Date: Mon, 09 Dec 2013 13:46:13 +0100
Message-id: <1731208.TRZ1kkpdkM@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1384866325-16110-1-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-3-git-send-email-ch.naveen@samsung.com>
 <1384866325-16110-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t/xa7oLdi8NMmh/xmzRcDXEYuOM9awW
	d58fZrR4eUjTYv6Rc6wWa/b/ZLLoXXCVzeLyrjlsFp97jzBazDi/j8li0bb/zBZPHvaxOfB4
	7Jx1l91j8Z6XTB59W1Yxehy/sZ3J4/MmuQDWKC6blNSczLLUIn27BK6MKZsmshdM46s4tOAR
	WwPjZu4uRk4OCQETiTsn17FB2GISF+6tB7K5OIQEljJKLLl2hQnC6WKSONnUzgJSxSagJvG5
	4RFYhwhQ9/FXZ9hBipgFljJJzF+2iBkkISwQIvG4dStYEYuAqsSXt99Yuxg5OHgFNCWmnlcF
	CfMLqEu82/aUCcQWFXCTeLFvCzuIzQlk7/rexQqxuIFR4uay7WBFvAKCEj8m3wM7gllAXmLf
	/qmsELaWxPqdx5kmMArOQlI2C0nZLCRlCxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKE
	xMuXHYyLj1kdYhTgYFTi4V3BujRIiDWxrLgy9xCjBAezkgiv2C6gEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsZFjyf7uEc4/o5sUNhwOONc58uU1c9euQn0/lxYsXsXw9Oqa5Hhr/9ufKmiIiSx
	23T/QqeNyfzyU1kYZyTO125q+LTx5zb7GoHTB/WXSnokNG95fEn89fZdvzc4P2EsWmvediuE
	bQvHTOM7WTqV+5lqvLk5P/wNPj1b/3t4Xvmy/Fbd5DMtH4uUWIozEg21mIuKEwHOpShDdQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On Tuesday 19 of November 2013 18:35:25 Naveen Krishna Chatradhi wrote:
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
> Changes since v9:
> Just respinning
> 
> Changes since v8:
> 1. rewrote the Documentation for device tree bindings
> 2. Merged the https://lkml.org/lkml/2013/11/7/262 (as this is a fix)
> 3. introduces "samsung,exynos5420-tmu-triminfo" and 
>    "samsung,exynos5420-tmu-triminfo-clk" to handle the TMU channels on
>    Exynos5420 more appropriately
> 
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   45 +++++++++
>  drivers/thermal/samsung/exynos_tmu.c               |   58 ++++++++++-
>  drivers/thermal/samsung/exynos_tmu.h               |    2 +
>  drivers/thermal/samsung/exynos_tmu_data.c          |  106 ++++++++++++++++++++
>  drivers/thermal/samsung/exynos_tmu_data.h          |    8 ++
>  5 files changed, 215 insertions(+), 4 deletions(-)

I have replied to previous version by mistake, but since this is just
a respin, same comments apply.

Best regards,
Tomasz

