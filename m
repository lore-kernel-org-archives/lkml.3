Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaCLPgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:36:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27755 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbaCLPg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:36:29 -0400
Date: Wed, 12 Mar 2014 16:35:54 +0100
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 0/4] devfreq: exynos4: Support dt and use common ppmu driver
In-reply-to: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, nm@ti.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@vger.kernel.org
Message-id: <25377064.TEmkdt3qR8@amdc1032>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7Bit
X-AuditID: cbfee61b-b7f456d000006dfd-d8-53207ef8d2aa
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jQd2fdQrBBueXMVtc//Kc1eJs0xt2
	i+4f2RaXd81hs/jce4TR4nbjCjaLNz/OMlk8XvGW3YHDY/Gel0wefVtWMXocv7GdyePzJrkA
	ligum5TUnMyy1CJ9uwSujO9n97IW3OOuOHlwGmsD43HOLkZODgkBE4lDTafYIGwxiQv31gPZ
	XBxCAtMZJb68f8kOkhASaGGSaFztCWKzCVhJTGxfxQhiiwhoSMz8e4URpIFZYA+jxNS+X6wg
	CWGBAInVp3aDTWURUJXYuPMhUJyDg1dAS2LyXUmQsKiAp8SO7SvBSjgFXCWurjnOCLHLReLP
	xS0sIDavgKDEj8n3wGxmAXmJffunskLYOhL7W6exTWAUmIWkbBaSsllIyhYwMq9iFE0tSC4o
	TkrPNdIrTswtLs1L10vOz93ECA7xZ9I7GFc1WBxiFOBgVOLhXagpHyzEmlhWXJl7iFGCg1lJ
	hPdpoUKwEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBsaS
	ouoP9yYVHqsMf5pVsd5VMpr/ws1ey4izpRuyAnu+P1px/1B8T/p5y64ZjQq3C+pezzeV/72G
	W/bljelXj8S/UiupOxb+KOthIstMBZ7gadcftc32Z15jxLZPaMEfzfUt347/2Gv9y6fy9Z8l
	ybu+Tjp5W69tyi+ZlY/5zV+H6BjUzHhwhdFIiaU4I9FQi7moOBEA/C4c3W0CAAA=
References: <1394624882-2989-1-git-send-email-cw00.choi@samsung.com>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, March 12, 2014 08:47:58 PM Chanwoo Choi wrote:
> This patchset support devicetree and use common ppmu driver instead of
> individual code of exynos4_bus.c to remove duplicate code. Also this patchset
> get the resources for busfreq from dt data by using DT helper function.
> - PPMU register address
> - PPMU clock
> - Regulator for INT/MIF block
> 
> This patchset use SET_SYSTEM_SLEEP_PM_OPS macro intead of legacy method.
> To remove power-leakage in suspend state, before entering suspend state,
> disable ppmu clocks.
> 
> Chanwoo Choi (4):
>   devfreq: exynos4: Support devicetree to get device id of Exynos4 SoC
>   devfreq: exynos4: Use common ppmu driver and get ppmu address from dt data
>   devfreq: exynos4: Add ppmu's clock control and code clean about regulator control
>   devfreq: exynos4: Use SET_SYSTEM_SLEEP_PM_OPS macro instead of legacy method
> 
>  drivers/devfreq/exynos/exynos4_bus.c | 396 ++++++++++++++++++++++++-----------
>  1 file changed, 271 insertions(+), 125 deletions(-)

The patchset generally looks OK, for my review comments please see separate
mails.  One thing I forgot to mention yet: please also fix DTS files so
exynos4_bus driver is finally functional (currently even with this patchset
it is not).

PS Please also add linux-samsung-soc@vger.kernel.org to Cc: when sending
the next revision of this patchset.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

