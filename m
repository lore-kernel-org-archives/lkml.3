Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaGUHjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:39:20 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:56902 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaGUHjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:39:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCHv7 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and code clean
Date: Mon, 21 Jul 2014 09:38:55 +0200
Message-ID: <14522743.f6oFhEQVv4@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
References: <1405909068-22539-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gqc2Au4yfmSwa+F0IK3dz+xDc3+fgUi+ByhVg/ut0pU
 HqebZmwRQy397Yiq2O0vGmPX8bdyzQFCOgElLb/aO+wsX6NjIf
 9AQOZQsvle/SIB88Pz0kY4fnv7Sh+7hfLf5p01e5cVZ0B0TDrH
 2H4DwCB2ExtHFRpJjXbKp44drNWKvyq1bk8CxpVJ5wpU4BSAZr
 f7WogSsdp1JQ6N5vMTZufaj8gqBbl26MK3ZYplfmXTcB8qs72A
 5i6JgazZoILGjn9/+BJWan6WoBcYW4llVqBff7ZBw2hURKTx6R
 FdPuUvZnkwJZvKA1EN5lrEijdZ3OMUU80AlFlOLW1uwtEbD07F
 4YWTsh3++peZE1/qgCTs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 July 2014 11:17:44 Chanwoo Choi wrote:
> 
> This patchset support Exynos3250 ADC (Analog Digital Converter) because
> Exynos3250 has additional special clock for ADC IP.
> 
> Changes from v6:
> - Use "exynos3250-adc" compatible string instead of "exynos3250-adc-v2"
> - Use "sclk" clock name instead of "sclk_adc"
> - Remove un-necessary macro for exyno-adc-data-v2 structure.
> - Remove '(void *)' cast and mark the exynos-adc-data structure as 'const'
> - Change the number of ADC channels (Exynos3250 has only two channels for ADC)
> 

Looks good to me. Two small requests:

a) if you don't mind, can you add my patch (1/2) to add support for s3c64xx to
   your series, adding your Signed-off-by line in addition to mine? I think
   that one was noncontroversial, while the second patch (2/2) need some more
   work to address the comments and do testing.

b) For the "compatible" string, I think it makes sense to set a fallback to
   "samsung,exynos-adc-v2" in the case for exynos3250, making the DT
   representation

	compatible = "samsung,exynos3250-adc", "samsung,exynos-adc-v2";

   It's not entirely compatible because of the addition of the clock, but
   since the register layout is the same, I think it still make sense.

Thanks.

For the entire series,

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
