Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab3IXJaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:30:18 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47157 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3IXJaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:30:12 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-88-52415ba3f500
From: Tomasz Figa <t.figa@samsung.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 0/6] thermal: exynos: Fixes for v3.12
Date: Tue, 24 Sep 2013 11:29:59 +0200
Message-id: <5975797.eclhCJt8Bu@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xy7qLox2DDA70C1g0XA2x2DhjPavF
	/CPnWC3W7P/JZNF59gmzxZtH3BZvHm5mtLi8aw6bxefeI4wWM87vY7K43biCzaJ/YS+TxZOH
	fWwOvB6L97xk8lg37S2zR9+WVYwejxa3MHocv7GdyePzJrkAtigum5TUnMyy1CJ9uwSujL5W
	44KdPBWLf0xlaWC8zNnFyMkhIWAicWrVDjYIW0ziwr31QDYXh5DAUkaJRT1/oZwuJokbS3Yy
	glSxCahJfG54BNYhIqAjceFjAzNIEbPAD2aJkwcus4MkhAUsJX7chShiEVCVmHT6C1icV0BT
	Ys+c3awgNr+AusS7bU+ZQGxRAVeJTws3gtVwCrhLtD+dArZMSMBN4u2jrSwQvYISPybfA7OZ
	BeQl9u2fygpha0ms33mcaQKj4CwkZbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5y
	fu4mRkgEfd3BuPSY1SFGAQ5GJR7eCwkOQUKsiWXFlbmHGCU4mJVEeG/YOgYJ8aYkVlalFuXH
	F5XmpBYfYmTi4JRqYJxdurN+3bpe7RW7FUwCLeoimA311T9vXcUXtWaFb8vTPJ8AKYeGrtj/
	qul5ttkmvGu5LQJO2R7Wnm0QO2Nf17dTTOwPw1IyFpZs97NpLA9hd3mh3rOy906I2bsP0QmM
	3+z3VpaULD6beGnOsjXHy6K1FSItFSUf93ApXd94/TtflFXxT8lYJZbijERDLeai4kQADO2f
	w34CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukasz,

On Tuesday 24 of September 2013 10:08:16 Lukasz Majewski wrote:
> This patch series is divided into two parts:
> 1. Device tree node definition and enabelement for TMU at Exynos4412 (Trats2)
> 2. Exynos thermal subsystem regressions for v3.12-rc1. Several commits were 
>    necessary to properly fix regression for TMU test MUX address setting after
>    reset.
> 
> Test HW:
> - Exynos4412 - TRATS2 board (Linux v3.12-rc1)
> 
> Lukasz Majewski (6):
>   thermal: exynos: fix: Return from exynos_report_trigger() when
>     therm_dev is NULL
>   thermal: exynos: Provide separate TMU data for Exynos4412
>   thermal: exynos: Provide initial setting for TMU's test MUX address
>     at Exynos4412
>   thermal: exynos: Replace SOC_ARCH_EXYNOS with SOC_ARCH_EXYNOS5250
>   ARM: dts: exynos4x12: Device tree node definition for TMU on
>     Exynos4x12
>   ARM: dts: exynos4412-trats2: Enable TMU support at Trats2
> 
>  arch/arm/boot/dts/exynos4412-trats2.dts         |    5 +++++
>  arch/arm/boot/dts/exynos4x12.dtsi               |   10 +++++++++
>  drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
>  drivers/thermal/samsung/exynos_tmu.c            |   12 +++++++----
>  drivers/thermal/samsung/exynos_tmu.h            |    3 ++-
>  drivers/thermal/samsung/exynos_tmu_data.c       |   26 +++++++++++++++++------
>  drivers/thermal/samsung/exynos_tmu_data.h       |   13 +++++++++++-
>  7 files changed, 58 insertions(+), 13 deletions(-)
> 

For the whole series:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

