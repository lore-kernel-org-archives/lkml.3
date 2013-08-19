Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976Ab3HSHpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 03:45:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53354 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3HSHpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 03:45:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC v1 5/5] ARM: mvebu: add board init for Armada 1500
Date: Mon, 19 Aug 2013 09:44:25 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Russell King <linux@arm.linux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <201308172108.38824.arnd@arndb.de> <52115262.70402@gmail.com>
In-Reply-To: <52115262.70402@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308190944.26177.arnd@arndb.de>
X-Provags-ID: V02:K0:dH/1X0PsauiO0FxLCktWwhUkhNlAzNPsmZ5Qa5KCu9k
 QRJz9WhGTbN+csPhWr3dI6BibWgwg3PvXpzBpZKRH9Ja7N8qNt
 2lUX1BX9/wQXJrUzMm0Vb7aFQiD8dwTR38sBZ9RC8RSkMpz37y
 p/YJH43f7Rzqx+BtVnw9hAPE2PZhajaxl0OhI3xF9d0TWYRd/A
 fQHmyjccmXlIJ0OATPYpqKKwtmw1Eh4kI0Pnw8s/6ovGGyAuQ9
 +nqLxvNqIvyUrmE/VYQFgo+O692ZTnUrwaxhEDIpd+z/WI5Rs7
 Jrla2WeHsYM7fIoTc2KRJda1gHhFybY7/8zuslKI1GenanGC87
 gVr9mdzkIxjJy1WSsIxU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 August 2013, Sebastian Hesselbarth wrote:
> > Note that we should really change the common code to do both the of_clk_init()
> > and the l2x0_of_init() automatically, but that needs to be done with some care,
> > in order to not break any of the existing platforms. Would you be able to do
> > one of the two? We can then get the next person that wants to add a platform
> > to do the last one ;-)
> 
> Scary but that reduces armada-1500.c to MACH descriptor and DT
> compatible only ;) I don't expect any weird hacks required for
> it anyway.

You will need the .smp_ops pointer once you add SMP support. Other than that,
if your machine descriptor only has the pointer to the compatible strings,
you can actually build without a machine descriptor (as we do on arm64).
The string is used only in /proc/cpuinfo then.

	Arnd
