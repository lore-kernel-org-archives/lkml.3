Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761352AbaGRJnl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:43:41 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50441 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760775AbaGRJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:43:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 1/4] iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
Date: Fri, 18 Jul 2014 11:42:35 +0200
Message-ID: <6186153.TIYp5NXPIq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405663186-26464-2-git-send-email-cw00.choi@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <1405663186-26464-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1vsPaCycwO2o7shgheOo8anqA/lB4nm21TlALw6BPiZ
 bxI69m0XahsWzFfEQsd5ZvJp+c+nlevl9O3CyYogiWWIeto1+p
 5ochEKQmrSKfNMPKtrq/66gLiLp6wacz24/ujkLAUkULaW0kFj
 KM9lvxlfsqIZH7BJmgGXMXUbwrP6R9+bwLRUxb1bKSB62Qd+gc
 ZrKundneqHrTod83z9TaxAKfnqe3xdYOoh9lnS36lRLJ4NpHSK
 NqGELJm0gVTRBsJSHUmieTPGbvTTuZwbCMj5onK3KgvMWIgzXQ
 lzawXhHKp9hd5jEdXPlo0z3r12SDmRPj4bglvysNoP7XMTlW30
 tCqKTf7We6k93X5OsKb4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 14:59:43 Chanwoo Choi wrote:
> This patchset add 'exynos_adc_data' structure which includes some functions
> to control ADC operation and specific data according to ADC version (v1 or v2).
> 

This new structure makes a lot of sense for covering the exynos specific
versions, but it will likely give a little more complexity for the
older models. We'll have to deal with that later then, no need to
hold up your patch. Interestingly, the version numbers seem weird. The
old driver uses

	{
                .name           = "s3c24xx-adc",
                .driver_data    = TYPE_ADCV1,
        }, {
                .name           = "s3c2443-adc",
                .driver_data    = TYPE_ADCV11,
        }, {
                .name           = "s3c2416-adc",
                .driver_data    = TYPE_ADCV12,
        }, {
                .name           = "s3c64xx-adc",
                .driver_data    = TYPE_ADCV2,
        }, {
                .name           = "samsung-adc-v3",
                .driver_data    = TYPE_ADCV3,
	}

Where TYPE_ADCV3 seems to be the same as the new ADC_V1 used in this
driver. Do you have an explanation for that?

	Arnd
