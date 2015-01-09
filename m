Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbbAITm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:42:58 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:51176 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbbAITm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:42:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Feng Kan <fkan@apm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        patches <patches@apm.com>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hieu Le <hnle@apm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 4/6] i2c: busses: add SLIMpro I2C device driver on APM X-Gene platform
Date: Fri, 09 Jan 2015 20:42:28 +0100
Message-ID: <15808906.L2zUs54agU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL85gmCOXKiHEO=URrAGBNZpJpen5P5PH1xDoF1-jasj0iDg4Q@mail.gmail.com>
References: <1412726809-7525-1-git-send-email-fkan@apm.com> <1894616.4yY7dajl4R@wuerfel> <CAL85gmCOXKiHEO=URrAGBNZpJpen5P5PH1xDoF1-jasj0iDg4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:R2Dm9RcorbXwNmGSwavKyrhTqFLdGaDbkukYs9hHpVTwl31isrc
 47+H1O1TI5FeErm7cKuId79pIc3hKzuFGa4bb6X8VpBqbsoLl+KLwLtxOBWfRyjXijdAQlS
 i3auG9kPQj98qOEcXMKjWFTEAOlVX0pZfbJmTjqA5QRMlvg4XHdeAp9Ht6EKn8tviSlTtXJ
 fvf0qdBzPW/QvOjAVNP+A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 10:56:51 Feng Kan wrote:
> On Tue, Nov 11, 2014 at 1:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Tuesday 07 October 2014 17:06:47 Feng Kan wrote:
> >> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> >> index 2e45ae3..a03042c 100644
> >> --- a/drivers/i2c/busses/Kconfig
> >> +++ b/drivers/i2c/busses/Kconfig
> >> @@ -1009,6 +1009,15 @@ config I2C_CROS_EC_TUNNEL
> >>         connected there. This will work whatever the interface used to
> >>         talk to the EC (SPI, I2C or LPC).
> >>
> >> +config I2C_XGENE_SLIMPRO
> >> +     tristate "APM X-Gene SoC I2C SLIMpro devices support"
> >> +     depends on ARCH_XGENE && XGENE_SLIMPRO_MBOX
> >
> > Why this dependency on XGENE_SLIMPRO_MBOX?
> >
> > Better replace it with a dependency on MAILBOX.
> Arnd, just a question. Is this because this possibly help with future
> compatibility by choosing a more broad dependency?

The dependency should ideally describe build-time dependencies,
to make it possible to build on other architectures for static
code analysis purposes. If the driver makes no sense on other
platforms you can also use

	depends on ARCH_XGENE || COMPILE_TEST
	depends on MAILBOX

to cover both the build-time and run-time dependencies. But the
dependency on XGENE_SLIMPRO_MBOX just shouldn't be there, the driver
will work with any mailbox implementation if someone puts the same
hardware into a different SoC.

	Arnd
