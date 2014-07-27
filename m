Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaG0Vtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 17:49:39 -0400
Received: from gloria.sntech.de ([95.129.55.99]:51164 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbaG0Vth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 17:49:37 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Hartmut Knaack <knaack.h@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, kgene.kim@samsung.com, pawel.moll@arm.com,
        t.figa@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>, kyungmin.park@samsung.com,
        linux-samsung-soc@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Ben Dooks <ben-linux@fluff.org>, galak@codeaurora.org,
        ch.naveen@samsung.com, linux-input <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v2] iio: exynos-adc: add experimental touchscreen support
Date: Sun, 27 Jul 2014 23:50:51 +0200
Message-ID: <1743122.0WWLup698P@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <53D56ABD.8080808@gmx.de>
References: <5068889.1KfVx3ksNo@wuerfel> <53D56ABD.8080808@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 27. Juli 2014, 23:10:21 schrieb Hartmut Knaack:
> Arnd Bergmann schrieb:
> > @@ -205,6 +217,9 @@ static void exynos_adc_v1_init_hw(struct exynos_adc
> > *info)> 
> >  	/* Enable 12-bit ADC resolution */
> >  	con1 |= ADC_V1_CON_RES;
> >  	writel(con1, ADC_V1_CON(info->regs));
> > 
> > +
> > +	/* set default touchscreen delay */
> 
> Any information about how many µs/ms it is actually set with this value?

"ADC conversion is delayed by counting this value. Counting clock is pclk."
So, I guess here 10000 pclk ticks.


Heiko

> 
> > +	writel(10000, ADC_V1_DLY(info->regs));
> > 
> >  }
> >  

