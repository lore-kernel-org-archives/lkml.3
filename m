Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbaDNSpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:45:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:63930 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaDNSpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:45:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, santosh.shilimkar@ti.com,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, w-kwok2@ti.com, rdunlap@infradead.org,
        sboyd@codeaurora.org, linux-kernel@vger.kernel.org, olof@lixom.net
Subject: Re: [PATCH v2 2/5] Power: reset: add bindings for keystone reset driver
Date: Mon, 14 Apr 2014 20:44:32 +0200
Message-ID: <6937937.4J6iI7VpBO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1397497283-16391-3-git-send-email-ivan.khoronzhuk@ti.com>
References: <1397497283-16391-1-git-send-email-ivan.khoronzhuk@ti.com> <1397497283-16391-3-git-send-email-ivan.khoronzhuk@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aZGnq0Ein+V8WXOEGj9/vzl3X0Ji+lOMkZR9zaaN1Yn
 tZ1ijCvCH9mJ+qVHod9uo+GrIXVS90VUE2fy6PCy1cgE9AjHKz
 xM83Lc8MoxQo7NjKZS3E73a2rReoaoNIjBFu7nU1CLBQGjZ9Ux
 U2d6mh5OZAhQaEsUTTRXXRGdsh0yAZEqvyL6clQRj724Nwp1WU
 s/KZrtMBmhdzC4ie2xilC+MboY2fhxyw0qKCn7aRJZG+LxT1Ox
 E2dQpBgzn3QVmYcclZZALPRyW2mk9ZP+Yroz/wpRJOGytz6dqC
 BrodoRdX1Oz9gHMwBlE8/Cz8f/xSmTQYiLMrKSd/+NUK0T7lCC
 Ndju1b7CdAj1O0Lz54d4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 April 2014 20:41:20 Ivan Khoronzhuk wrote:
> +Optional properties:
> +
> +- ti,soft-reset:       Boolean option indicating soft reset.
> +                       By default hard reset is used.
> +
> +- ti,wdt_list:         WDT list that can cause SoC reset.
> +                       The list in format: <0>, <2>;
> +                       Begins from 0 to 3, as keystone can contain up
> +                       to 4 SoC reset watchdogs.
> 

This looks like your binding just describes a subset of the
watchdog timer registers. If so, don't do a standalone reset
driver, but instead do a watchdog driver that can also be
used for reset, and have a binding that properly describes
the watchdog hardware.

It is bad to have overlapping register ranges between logical
devices, and it's also generally wrong to describe devices that
are not actually there: The hardware contains a watchdog, not
a system-reset device, so you should not make one up because
it seems easier given the Linux driver model.

	Arnd
