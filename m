Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaLTUMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:12:08 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:53680 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaLTUMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:12:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] mfd: cottula: add cottula board
Date: Sat, 20 Dec 2014 21:11:59 +0100
Message-ID: <1591685.mRlCV6MZRs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <8761d68xm3.fsf@free.fr>
References: <1418598606-21352-1-git-send-email-robert.jarzmik@free.fr> <877fxsapds.fsf@free.fr> <8761d68xm3.fsf@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:Oq5ymym0vVhPg7BDUT4Zi/zJq7W3mZsh7Va7w1Jmh3F94eGsJgn
 XamfYH2dfcjFAfnSMZuaXJnUMPAyoK40GS/xsb1r6geovdU+WRuAR0Um6DLIdG/VeJP3KJW
 D7zocZTG1fJhwZcgLzrTJGKv6Fpb3OrMxwhgTYabB30V34a3Mr5dLfMMUn8Zow7+DhqYRrM
 QN+fQpB+lkGD6EjfynrMg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2014 10:43:48 Robert Jarzmik wrote:
> Robert Jarzmik <robert.jarzmik@free.fr> writes:
> > Arnd Bergmann <arnd@arndb.de> writes:
> >> This looks a bit ambiguous: You get a GPIO line for the purpose of the
> >> IRQ nesting but don't use the GPIO otherwise, and you pass the device's
> >> own irq domain start as an IORESOURCE_IRQ resource.
> >>
> >> For consistency between DT and ATAGS based uses, and with similar DT
> >> based drivers, I would instead recommend passing the parent irq (from
> >> the GPIO) as an IORESOURCE_IRQ resource instead of a gpio lookup,
> >> and passing the base_irq as platform_data for the ATAGS case.
> 
> Hi Arnd,
> 
> I thought again about the GPIO.
> 
> I put in the "gpiod_get()" call to ensure proper ordering between the gpio
> probing and this driver probing. It ensured that this driver's probe will be
> defered until the gpio driver is probed, which is the main purpose of this
> patch (commit message).
> 
> If I pass an irq from the machine code, I loose this guarantee, don't I ?

Not sure, my guess is that it could still work the same way because
the irq is not registered yet and request_irq or similar will fail.

	Arnd
