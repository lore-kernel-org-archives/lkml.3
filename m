Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3H1Kiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:38:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44994 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3H1Kil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:38:41 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-ab-521dd32f3f41
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        naveenkrishna.ch@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2: 3/3] thermal: samsung: Add TMU support for Exynos5420
 SoCs
Date: Wed, 28 Aug 2013 12:38:31 +0200
Message-id: <2432994.TkQmThmFSA@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1377681409-18166-3-git-send-email-ch.naveen@samsung.com>
References: <1375336979-14747-1-git-send-email-ch.naveen@samsung.com>
 <1377681409-18166-1-git-send-email-ch.naveen@samsung.com>
 <1377681409-18166-3-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9jQV2Dy7JBBmt+Mls0XA2xuPv8MKPF
	/CPnWC3W7P/JZNG74CqbxeVdc9gsPvceYbSYcX4fk8Wibf+ZLZ487GNz4PLYOesuu8fiPS+Z
	PPq2rGL0OH5jO5PH501yAaxRXDYpqTmZZalF+nYJXBmXJi9mLHjKU3F26nS2BsaNXF2MnBwS
	AiYSMxccZYSwxSQu3FvP1sXIxSEkMJ1R4vXZbcwQTguTxJM5nWwgVWwCVhIT21eBdYgAdR9/
	dYYdxGYW+MkoMbu7HMQWFgiRaF33kwXEZhFQlbh/dwsziM0roCkx8elVsDmiAp4SnyYtBYtz
	CrhJrF/8jwVi2V5Gibcdj5kgGgQlfky+xwKxQF5i3/6prBC2jsT+1mlsExgFZiEpm4WkbBaS
	sgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqPgmfQOxlUNFocYBTgYlXh4LTbLBAmx
	JpYVV+YeYpTgYFYS4eXfLhskxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdgq3WgkEB6Yklqdmpq
	QWoRTJaJg1OqgbGmYtNTtzkHzKPmXNj6ak7Ff81J8s+VS1gcK6X05p6J+L6CfSZ77PqsmQH9
	x4TXdRpeeOR5mbdqm0v/7s+BiysXzIubbX/lUXjGTJbAH+3rF/A6rE5tCc9rDBLOUT6YfP/0
	fPHa3jzWvy4Hdi2Y82tdlHuX22WhU2u1bzly3U06dvZCYL3mmVNKLMUZiYZazEXFiQBGe5mI
	fgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, August 28, 2013 02:46:49 PM Naveen Krishna Chatradhi wrote:
> This patch adds the neccessary register changes and arch information
> to support Exynos5420 SoCs
> Exynos5420 has 5 TMU channels one for each CPU 0, 1, 2 and 3 and GPU
> 
> Note: The platform data structure will be handled properly once the driver
>  moves to complete device driver solution.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

OK, this is also an acceptable solution (though it seems to be worse
in terms of simplicity and long term maintainance). Anyway please ignore
my comments to v1, just remember to rename this flag (as already pointed
by out by Amit). TMU_SUPPORT_SHARED_MEMORY documentation in exynos_tmu.h
also requires an update.

> ---
> Changes since v1:
> 1. modified the platform data structure in order to pass SHARED flag
>    for channels that need sharing of address space.
> 2. https://lkml.org/lkml/2013/8/1/38 is merged into this patch.
>    As the changes are minimum and can be added here.

Documentation/devicetree/bindings/thermal/exynos-thermal.txt update got
lost and it is quite important now as second address servers multiple
purposes. Please fix it.

>  drivers/thermal/samsung/exynos_tmu.c      |   14 +++-
>  drivers/thermal/samsung/exynos_tmu.h      |    1 +
>  drivers/thermal/samsung/exynos_tmu_data.c |  130 +++++++++++++++++++++++++++++
>  drivers/thermal/samsung/exynos_tmu_data.h |    7 ++
>  4 files changed, 150 insertions(+), 2 deletions(-)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

