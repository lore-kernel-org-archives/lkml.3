Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935111AbaGRQbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:31:53 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:52948 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaGRQbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:31:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chanwoo Choi <cwchoi00@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-iio@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        galak@codeaurora.org, naveen krishna <ch.naveen@samsung.com>,
        jic23@kernel.org
Subject: Re: [PATCHv6 2/4] iio: adc: exynos_adc: Control special clock of ADC to support Exynos3250 ADC
Date: Fri, 18 Jul 2014 18:31:40 +0200
Message-ID: <10264770.8SXiIS8qhq@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGTfZH3vz9MLN+1fPM22zKE64oMNDgcib3is0nfzZhhLkmdNvw@mail.gmail.com>
References: <1405663186-26464-1-git-send-email-cw00.choi@samsung.com> <32226622.5gSmvBRKvZ@wuerfel> <CAGTfZH3vz9MLN+1fPM22zKE64oMNDgcib3is0nfzZhhLkmdNvw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dl75VlJUepIMnpfzA5SFy87pVStdHBrN4T8H8mQM1OK
 wAJrvnTjIBEw6bQatU+Ggs4LFj10rbJVeBbGMNUtPytcpPoHUD
 0KEblw6YDBQdFHmZuGveyVvp5Kj9W0QzX+yKa93eRAEZRUk6zL
 vZKqAMVhSJIkZFxxHI9vz69LA/n5Oe9jvvdAdeU3EwtOVSUV/8
 /ywwGoJi/C/PxvQNA/YRNOgkfRg0ojoBiMQqEfrG7ZfCcS1/Ej
 G++6bro9AKGpljpDYkXpRePGy0kqsMf1aSEMExW22+UqExmXWy
 E+Ev5RA9lsm9gqbggbEvxYt4/aiJSPI3HrnZPmpc3PXu40V+Wu
 OnRvfqpu7fYOqxiifHi0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 July 2014 01:11:53 Chanwoo Choi wrote:
> 
>   Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>   - 'adc' clock: bus clock for ADC
> 
>   Exynos3250 has additional 'sclk_adc' clock as following:
>   - 'sclk_adc' clock: special clock for ADC which provide clock to internal ADC

The bus clock is often named "apb_pclk", but it's too late to change
that now, and it's not clear if the device is actually on APB.

The problem with "sclk_adc" is that it's very close to the name used
in the clock provider, with is CLK_SCLK_TSADC. Please try to avoid
the ambiguity here and make it clear that they are not referring
to the same thing. "internal" or "special" might be good if you want
to avoid "sclk".

	Arnd
