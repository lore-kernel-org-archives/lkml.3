Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaIXHZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:25:34 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27385 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaIXHZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:25:32 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-9e-542271e9c6f7
Message-id: <542271E8.4020606@samsung.com>
Date: Wed, 24 Sep 2014 09:25:28 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 0/5] pinctrl: samsung: Data structure clean-up
References: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
In-reply-to: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7ovC5VCDLY+k7HYOGM9q0Xvgqts
	FlP+LGey2PT4GqvF5V1z2CxmnN/HZLFq1x9GB3aPnbPusnvcubaHzWPzknqPvi2rGD0+b5IL
	YI3isklJzcksSy3St0vgypj45Q9rwSuRincHrrM2ML7l72Lk4JAQMJHouB/cxcgJZIpJXLi3
	nq2LkYtDSGApo8SX5q1QzidGiWOvXjOCVPEKaEl8nbmNDcRmEVCV2Dv3MlicTcBQouttF1hc
	VCBGYunHPSwQ9YISPybfA7NFBLwkWnZfYwEZyixwjlGi/+M3ZpCEsICTxNo9b8FsIQFXiffv
	1oIN4hRwk/h7/BcriM0sYCbx5eVhKFteYvOat8wTGAVmIdkxC0nZLCRlCxiZVzGKppYmFxQn
	peca6RUn5haX5qXrJefnbmKEBPnXHYxLj1kdYhTgYFTi4Z0orhQixJpYVlyZe4hRgoNZSYT3
	eDZQiDclsbIqtSg/vqg0J7X4ECMTB6dUA6NUVULnymWvT9RO/+y0TIeJrbfAUGrtvtVzmO+z
	1xUd/uTSsi5F/uTv1XZnltV6LVC0vryL87XDujDnu9NPbPK+97Hh19E9Runh5y7bnJvIHay+
	J7NHl1v6O2enqN+KUPnn9TbHrvZe4uK92HV4/wSlC1flgv1KHZ6LZXLwG79VemQrb3GnSUCJ
	pTgj0VCLuag4EQC+raUlUAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-09-23 21:05, Tomasz Figa wrote:
> This series intends to clean up data structures used by pinctrl-samsung driver.
> More specifically, it separates initial compile time constants from data used
> at runtime, allowing unused variant data to be dropped and selected structures
> constified to improve safety.
>
> As a side effect, size of vmlinux built from multi_v7_defconfig was reduced
> from:
>
>   text     data    bss    dec      hex    filename
>   10296708 1227100 313544 11837352 b49fa8 vmlinux
>
> to:
>
>   text     data    bss    dec      hex    filename
>   10296740 1176860 313544 11787144 b3db88 vmlinux
>
> and quite a bit of data were moved from normal data sections to .init.data:
>
> pre:
>
> Idx Name          Size      VMA       LMA       File off  Algn
>    3 .rodata       0026c080  c0881000  c0881000  00681000  2**6
>   23 .init.data    0003ff7c  c0bdb830  c0bdb830  009e3830  2**3
>   24 .data..percpu 00002100  c0c1c000  c0c1c000  00a24000  2**6
>   25 .data         000e98e0  c0c20000  c0c20000  00a28000  2**6
>
> post:
>
> Idx Name          Size      VMA       LMA       File off  Algn
>    3 .rodata       0026bf20  c0881000  c0881000  00681000  2**6
>   23 .init.data    00041bbc  c0bdb830  c0bdb830  009e3830  2**3
>   24 .data..percpu 00002100  c0c1e000  c0c1e000  00a26000  2**6
>   25 .data         000db860  c0c22000  c0c22000  00a2a000  2**6
>
> This series should not introduce any functional changes.
>
> Tested on S3C6410-based Mini6410 board, booting with device tree.
>
> Marek, Bart, could you do some testing on Exynos-based boards,
> just to make sure?

Works fine on Exynos4412 based OdroidU3+ and Exynos4210 Universal C210.

For the whole patchset:
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

> Tomasz Figa (5):
>    pinctrl: samsung: Make samsung_pinctrl_get_soc_data use ERR_PTR()
>    pinctrl: samsung: Drop unused label field in samsung_pin_ctrl struct
>    pinctrl: samsung: Constify samsung_pin_bank_type struct
>    pinctrl: samsung: Constify samsung_pin_ctrl struct
>    pinctrl: samsung: Separate per-bank init and runtime data
>
>   drivers/pinctrl/samsung/pinctrl-exynos.c  | 113 +++++++++++----------------
>   drivers/pinctrl/samsung/pinctrl-s3c24xx.c |  30 +++----
>   drivers/pinctrl/samsung/pinctrl-s3c64xx.c |  31 ++++----
>   drivers/pinctrl/samsung/pinctrl-samsung.c | 126 ++++++++++++++++--------------
>   drivers/pinctrl/samsung/pinctrl-samsung.h |  78 ++++++++++++------
>   5 files changed, 193 insertions(+), 185 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

