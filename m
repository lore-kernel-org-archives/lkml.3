Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab3LKOxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:53:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab3LKOxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:53:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
Date: Wed, 11 Dec 2013 15:53:41 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Mack <zonque@gmail.com>, Olof Johansson <olof@lixom.net>,
        Eric Miao <eric.y.miao@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com> <201312110611.46443.arnd@arndb.de> <1386740489.7152.288.camel@host5.omatika.ru>
In-Reply-To: <1386740489.7152.288.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312111553.42076.arnd@arndb.de>
X-Provags-ID: V02:K0:CNpIIH5uCk7WBS/Atwdn6VXjALXbTLe9PUf2SC8yUbd
 GbEgdVIrEUPtOe+zdL7dGzkvgShj4mcSO42q4owWUjR85FrFVl
 EPlrfN9aSbovNsVc0qpzl65zckx5mO/HrGFjaTVjW6+rM4sKM0
 KmorKvy+5aJZ7a4kmkQegFGSA5MlPDq1CUu6VAgcwfbhbfRkVM
 Pw4eNsrepDf3QDqtH/F3bbkKJP1B91AaMC/EM4zUX28QquzNsh
 1T4Zo/MUjyhwNQb65wpiw6FmZX8AGeJZHX1seXNoOAw/4xr+9v
 /W207DxxwNu+IzUa7e5g/f3RBfF5L7gFMT1quH/9pV0Me0m/vp
 lDoGzlt7irbRWl5v0G0c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 December 2013, Sergei Ianovich wrote:
> On Wed, 2013-12-11 at 06:11 +0100, Arnd Bergmann wrote:
> > It depends: if the driver is for the entire FPGA and does
> > the irqchip stuff in addition, it should probably live
> > in drivers/mfd. If it's a pure irqchip driver, drivers/irqchip
> > is better. You have to be careful in the second case though
> > because devices pointing to this irqchip in DT won't get
> > an IRQ resource assigned automatically but have to use
> > irq_of_parse_and_map instead. This may have been fixed since
> > I last looked though, I would consider that behavior a
> > bug in the of_platform handling.
> 
> Thanks again for explaining.
> 
> Although FPGA is a MFD, its irq are used mostly by 8250 serial ports. It
> will be enough to embed irqchip into serial driver for now.
> 
> If there is a need to use the chip in another driver, it will be
> possible to introduce an artificial dependency there for the serial
> driver to ensure the serial driver is loaded before the other one.
> 
> Is this plan acceptable?
> 

If you already have an MFD driver, I think it's more logical to put
the irqchip in there, we have a number of other MFD drivers doing the
same but I have not seen a UART driver that comes with its own irqchip.

	Arnd
