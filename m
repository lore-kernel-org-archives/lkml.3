Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358Ab3JCN36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:29:58 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:49761 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab3JCN34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:29:56 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-bd-524d71522cbc
Date: Thu, 03 Oct 2013 15:29:47 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 0/6] thermal: exynos: Fixes for v3.12
Message-id: <20131003152947.7c39a16b@amdc308.digital.local>
In-reply-to: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e+xoG5QoW+QQeMSHYuGqyEWG2esZ7WY
	f+Qcq8Wa/T+ZLDrPPmG2ePOI2+LNw82MFpd3zWGz+Nx7hNFixvl9TBa3G1ewWfQv7GWyePKw
	j81i/YzXLA58Hov3vGTyWDftLbNH35ZVjB6PFrcwehy/sZ3J4/MmuQC2KC6blNSczLLUIn27
	BK6M/p0fWQqO81Z8aWpmbGA8yNXFyMkhIWAi0fP+LiuELSZx4d56ti5GLg4hgemMEru2dzNB
	OO1MEh/eL2QGqWIRUJV4+vcUmM0moCfx+e5TsCIRgSZGiR9HvjGDOMwCR5glWi63MYFUCQtY
	Svy4+whoLgcHr4C1xNonHiBhTgF3ifanUxhBbCEBN4m3j7aygNj8ApIS7f9+MEOcZCdx7tMG
	dhCbV0BQ4sfke2A1zAJaEpu3NbFC2PISm9e8ZZ7AKDgLSdksJGWzkJQtYGRexSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iREcTc+kdjCubLA4xCjAwajEw2ug5BMkxJpYVlyZe4hRgoNZSYT3
	W55vkBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGC894
	s3/lFj7R8plQY/Plj3n/q+CZ/F1pHhpz5sY8cmD90zz95K1Cv2tTWhJjhBI0XOYYXFtw0lFi
	ql+u36sLbzsY7op9kN1zTnhtrLu3dItCjNoVPRnz76X6x8LqNr2W2nC7+oai/Bm1OQsEb6/Y
	+DvU5mPDYzGe8qtz5S/G/1m/ec7r+YInlFiKMxINtZiLihMBNjRTCqICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

> This patch series is divided into two parts:
> 1. Device tree node definition and enabelement for TMU at Exynos4412
> (Trats2) 2. Exynos thermal subsystem regressions for v3.12-rc1.
> Several commits were necessary to properly fix regression for TMU
> test MUX address setting after reset.

Zhang or Eduardo - will you find time to review those changes?
They have already been reviewed by Amit.

Now we have -rc3 and there is no feedback for regression/critical
patches (posted for -rc1).

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
>  drivers/thermal/samsung/exynos_tmu_data.c       |   26
> +++++++++++++++++------
> drivers/thermal/samsung/exynos_tmu_data.h       |   13 +++++++++++- 7
> files changed, 58 insertions(+), 13 deletions(-)
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
