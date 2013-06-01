Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3FAI4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 04:56:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59769 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3FAI4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 04:56:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] watchdog: New watchdog driver for MEN A21 watchdogs
Date: Sat, 01 Jun 2013 10:56:16 +0200
Message-ID: <2637599.Z6OQQQSYxb@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <20130531085842.GA8572@jtlinux>
References: <20130531085842.GA8572@jtlinux>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:W/Cye6AWTJEvmAd8A9RUnPsaFQIiZfxrZGzHXB9obg2
 Q5ydiQyoGhNRnz1lUH19+VUIof+qu8fmu3ptKwtRXxKy3OakjA
 cPddwQgRFgyZMRJbysIABVijE4lIEkh0a+fh3Zna2SbBhw6ke0
 +cOCv5poytIkXuv0GrRRdduQgvBX2XMKEIwFfOBbRsCvjl6iyQ
 n9JwgdsXYDNaDFFci3fhu8M+wuh0nl1x7Vv2kSityNnntVt+bB
 B9Isdm+laRKnDzdRucWQrkzzgui0dFeALCVuhMyC2rDOVaibS+
 p4FrvTEAgxdeeG4ZPPjtWH5B1dCTuJw/mob5mApAU5ibabip2Y
 egeDEtdF4eiyMKxH/OYo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 10:58:48 Johannes Thumshirn wrote:
> This patch adds the driver for the watchdog devices found on MEN Mikro
> Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
> watchdog framework.
> 

It seems the DT support is rather incomplete


> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  MAINTAINERS                   |    6 ++
>  drivers/watchdog/Kconfig      |    8 ++
>  drivers/watchdog/Makefile     |    1 +

Please add a binding document to Documentation/devicetree/bindings/

> +
> +#define GPIO_WD_ENAB	169
> +#define GPIO_WD_FAST	170
> +#define GPIO_WD_TRIG	171
> +
> +#define GPIO_RST_CAUSE_BASE 166

You should never hardwire GPIO numbers like this. There is a DT binding
for GPIO, so use that to get the number of the tree.

	Arnd
