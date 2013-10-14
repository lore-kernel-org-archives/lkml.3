Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3JNFqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:46:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58771 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3JNFqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:46:43 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-a4-525b8541a933
Date: Mon, 14 Oct 2013 07:46:35 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, kgene.kim@samsung.com
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 0/5] thermal: exynos: Fixes for v3.12
Message-id: <20131014074635.77fd9f6e@amdc308.digital.local>
In-reply-to: <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
References: <1380010102-25817-1-git-send-email-l.majewski@samsung.com>
 <1381300194-13134-1-git-send-email-l.majewski@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jAV3H1ugggxVrrS0aroZYbJyxntVi
	/pFzrBZr9v9ksuhdcJXN4s0jbos3DzczWlzeNYfN4nPvEUaLGef3MVk8edjH5sDtsXjPSyaP
	ddPeMnv0bVnF6HH8xnYmj8+b5AJYo7hsUlJzMstSi/TtErgyzrRsZilo5q1YPvkcawNjB1cX
	IyeHhICJxIsddxkhbDGJC/fWs3UxcnEICSxilHjSN5sJwmlnkrg1rQWsikVAVWLvvG0sIDab
	gJ7E57tPmUBsEYEMiVOXIBqYBW4zSSxpXcUKkhAWsJG4tu4KWDOvgLXEj/7d7CA2p4C7xME7
	79ghNjQzSjy6uAlsKr+ApET7vx/MEDfZSZz7tIEdollQ4sfke2A1zAJaEpu3NbFC2PISm9e8
	ZZ7AKDgLSdksJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcJ8+kdjCubLA4
	xCjAwajEwyvgFB0kxJpYVlyZe4hRgoNZSYT3ah1QiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+B
	VutAIYH0xJLU7NTUgtQimCwTB6dUA6PRxJ6pR5jOhmtJZVzx3yv26Kl6e90cy2zjJWE7b73e
	7f504TtmRckpCjryE7f9PnSiNurhJ7Y38z0XJNYcdb/JPpWPzUbq9L+VDL6SzG8zvbQumjsl
	x/7RfH7sfq/S3KnG8QG1vyLk2kJ3uHgLbmdfyPinmz8/2+/Q5HNfZjCruBaWTZDxT1ViKc5I
	NNRiLipOBAD5Fcv4jwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhang, Eduardo,

> This patch series is divided into two parts:
> 1. Device tree node definition and enabelement for TMU at Exynos4412
> (Trats2) 2. Exynos thermal subsystem regressions for v3.12-rc4.
> Several commits were necessary to properly fix regression for TMU
> test MUX address setting after reset.
> 
> Test HW:
> - Exynos4412 - TRATS2 board (Linux v3.12-rc4)
> SHA1: 8b5ede69d24db939f52b47effff2f6fe1e83e08b
> 
> 
> Lukasz Majewski (5):
>   thermal: exynos: Remove check for thermal device pointer at
>     exynos_report_trigger()
>   thermal: exynos: Provide separate TMU data for Exynos4412
>   thermal: exynos: Provide initial setting for TMU's test MUX address
>     at Exynos4412
>   ARM: dts: exynos4x12: Device tree node definition for TMU on
>     Exynos4x12
>   ARM: dts: exynos4412-trats2: Enable TMU support at Trats2
> 

Zhang, Eduardo - any comments?

Would it be possible to add them to v3.12 since they do fix critical
error and regression on Exynos4412.


>  arch/arm/boot/dts/exynos4412-trats2.dts         |    5 ++++
>  arch/arm/boot/dts/exynos4x12.dtsi               |   10 ++++++++
>  drivers/thermal/samsung/exynos_thermal_common.c |    2 --
>  drivers/thermal/samsung/exynos_tmu.c            |   12 ++++++---
>  drivers/thermal/samsung/exynos_tmu.h            |    7 +++++-
>  drivers/thermal/samsung/exynos_tmu_data.c       |   30
> ++++++++++++++++++-----
> drivers/thermal/samsung/exynos_tmu_data.h       |   13 +++++++++- 7
> files changed, 65 insertions(+), 14 deletions(-)
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
