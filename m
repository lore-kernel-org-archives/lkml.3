Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab3LKFMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 00:12:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57160 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3LKFMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 00:12:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 02/11] arm: pxa27x: support ICP DAS LP-8x4x
Date: Wed, 11 Dec 2013 06:11:46 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sergei Ianovich <ynvich@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Daniel Mack <zonque@gmail.com>, Olof Johansson <olof@lixom.net>,
        Eric Miao <eric.y.miao@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com> <201312102257.33942.arnd@arndb.de> <1386736215.7152.259.camel@host5.omatika.ru>
In-Reply-To: <1386736215.7152.259.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312110611.46443.arnd@arndb.de>
X-Provags-ID: V02:K0:QL52f64LqYMAedamvS2Toqp048dKaFTEPKWc6sLzccH
 i9tQce8Pfss7lK/8hPFWc6I/LNx3lbTx3+oRnWmYesao8osXsd
 piBnq0Tb7J0U5C5mP48mDWWTHJBjxYLn2kkloZkxANV4xeSHlX
 urnnKLcOn14VKdBdOSE8I2+2OcslfglgMDE41duc3jcIq0DAqK
 rf/UkJKDDPe5EzAdu7BCwQRiSD8xuDrlAih2aEkNhIYLlUgc77
 U0RTWKfWdXoVUsZ8BvxzWuXvuD5G7gXWKOeGOeK6t2mW4epNdA
 h8M7Ufdm0S3/Os9D+rR0sHX4Dyul9lcHdVkQEAQh0Rg2qcyPvH
 AHrRNZroyOyJZT/v2PFg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 December 2013, Sergei Ianovich wrote:
> > It probably makes sense to have a single driver file for the
> > FPGA device that does this, and only split out the other devices
> > from it that consume the irqs.
> 
> Is drivers/irqchip/ the right place this driver?
> 
> I am asking because there is no tristate config options in
> drivers/irqchip/Kconfig at the moment.
> 

It depends: if the driver is for the entire FPGA and does
the irqchip stuff in addition, it should probably live
in drivers/mfd. If it's a pure irqchip driver, drivers/irqchip
is better. You have to be careful in the second case though
because devices pointing to this irqchip in DT won't get
an IRQ resource assigned automatically but have to use
irq_of_parse_and_map instead. This may have been fixed since
I last looked though, I would consider that behavior a
bug in the of_platform handling.

	Arnd
