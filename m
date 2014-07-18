Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbaGRJjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:39:33 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55253 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761066AbaGRJja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:39:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, jic23@kernel.org,
        ch.naveen@samsung.com, mark.rutland@arm.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        t.figa@samsung.com, rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kyungmin.park@samsung.com, robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCHv6 0/4] iio: adc: exynos_adc: Support Exynos3250 ADC and code clean
Date: Fri, 18 Jul 2014 11:38:27 +0200
Message-ID: <59765980.V0Hsx6tyKd@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:jNnSoEbHlzmfSLEDh9P0sfEHpway0dW3NY+zr5Mck69
 bhVVx8O+G6FOffjAJ3mbkafj4YbdFeonHdUxIHOPiBtHAJGRyn
 V2RMQW+Lb5zNM/PFnbdEstpcodOJZPTLH7QDbpfSXZFoWkhvyG
 APqKq7Kp38C3voNbuqa3v+FeBKeAcpLYkH0wbE3tmWbCo9Yola
 ChKySBvGP7osDFRn8dPXWmBghT3h0cWADe8mvBU9my4mmaUBO2
 txdw9HMmq36q/TNJ3D7cimtQX8C4uhG/8APNd3USvLcatgDRPz
 jESddJnnaHK3FGZUy9tOyvKQRp6qfNgJsoRKknWV/SGPXLZrA5
 IK/PZxLlbyMGLyrCSjvs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 July 2014 14:59:42 Chanwoo Choi wrote:
> This patchset support Exynos3250 ADC (Analog Digital Converter) because
> Exynos3250 has additional special clock for ADC IP.
> 

by coincidence, I have just looked at the same driver in order to
add support for s3c24xx and s3c64xx, so we can remove the plat-samsung
adc framework they still use.  Those changes would naturally conflict
with yours, but I think it makes sense for your patches to come first.

I'll comment a bit more on the individual patches. I didn't have
interest in them earlier, so I didn't comment so far.

Another aspect that came up is the touchscreen support. Right now,
there is drivers/input/touchscreen/s3c2410_ts.c which is intimately
tied to arch/arm/plat-samsung/adc.c. The best way forward (as discussed
on IRC as few days ago) seems to be to integrate support for that into
the exynos_adc driver. Can you comment on which parts actually support
touchscreen? Did touchscreen support get dropped in the exynos hardware,
or is the driver just missing at the moment?

	Arnd
