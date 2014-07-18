Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbaGRLR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 07:17:59 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:63166 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbaGRLR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 07:17:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        My self <ch.naveen@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, kyungmin.park@samsung.com, t.figa@samsung.com,
        linux-iio@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv6 1/4] iio: adc: exynos_adc: Add exynos_adc_data structure to improve readability
Date: Fri, 18 Jul 2014 13:16:53 +0200
Message-ID: <237819296.s52Lu0h5nW@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAHfPSqBDOEH5HurG=rECV=d+MM_YjTEpsiwuTgtNgFgCQ0P2bw@mail.gmail.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <6186153.TIYp5NXPIq@wuerfel> <CAHfPSqBDOEH5HurG=rECV=d+MM_YjTEpsiwuTgtNgFgCQ0P2bw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zMQNAgf3MzaCnl1hiMe63P3/D3yRiJKYi5f+J8t9UXT
 S2Ibx0t1XDT6xy2YIZCTtuPxKEqZvml5fX5YjZV79i+sRN+rrs
 x6iw0aG56QL46F0aeQ/cXCzlnNkEkKPNeEw9/Smi4thNzJ4cjq
 fydvS2NZ4YR3JoLtNJSBteVrseSgnSMIP3NC7I/tS3X0C8cdyj
 gjN7PJX0HJ5bM/AR5JNFQbuYBj56igBqns3ujIn8LMKHxYEf0J
 aHlA6CBtJd0pWZgQ0JixDMAiiepidLx51kxZUDiwKLfrYhOBdW
 9ypMg7oHIHpoVqJzxTouOp0CJktKdNzPhzV7VdVNIAvfyPmcXc
 u2Gks32FKgADVgY3TnuQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 15:41:27 Naveen Krishna Ch wrote:
> >
> >         {
> >                 .name           = "s3c24xx-adc",
> >                 .driver_data    = TYPE_ADCV1,
> >         }, {
> >                 .name           = "s3c2443-adc",
> >                 .driver_data    = TYPE_ADCV11,
> >         }, {
> >                 .name           = "s3c2416-adc",
> >                 .driver_data    = TYPE_ADCV12,
> >         }, {
> >                 .name           = "s3c64xx-adc",
> >                 .driver_data    = TYPE_ADCV2,
> >         }, {
> >                 .name           = "samsung-adc-v3",
> >                 .driver_data    = TYPE_ADCV3,
> >         }
> >
> > Where TYPE_ADCV3 seems to be the same as the new ADC_V1 used in this
> > driver. Do you have an explanation for that?
> 
> As per suggestion from Doug Anderson,
> I've implemented IIO based ADC driver to work with Exynos5250.
> keeping the plat-samsung/adc.c unchanged.
> 
> Assuming Exynos5250 is the one using the driver for the first time.
> i've named it v1 and so on.
> 
> Now, This seems to cause a lot of confusion.

Ah, so the version numbers don't come from Samsung hardware
documents but are just counting the versions we have drivers
for?

In this case, I guess using the first SoC that had a particular
version would have been better, and we should probably do that
when we add support for the older hardware in this driver.

	Arnd
