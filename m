Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaIIJ12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:27:28 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57352 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaIIJ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:27:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, Olof Johansson <olof@lixom.net>,
        arm@kernel.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.18 #2
Date: Tue, 09 Sep 2014 11:27:12 +0200
Message-ID: <3053665.vhA4jELi7x@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140909091520.GJ3804@lukather>
References: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com> <26517543.McM8Q5P0vn@wuerfel> <20140909091520.GJ3804@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WC4Geu6A+KOUAMe6QXkemyRunFe/oE0lg5bTg/EOVUv
 ukLXPnZfM7V7K54DLSdqmJNYqle7CUlCDVP/4RcY5aYuxvZJlU
 MwvcJOmdcxugfB0qUylgDFUIWPmrua8wqYtp/fdMo6LJzIMZbZ
 tGcBg5SdgqQhSFXCh4Gy8u6rEDU9YltoYx0XZd8lte0CSaW2YO
 PMa9ov5ZyJEQaPtYymAZa1rNXQ3LifdKeHxG/JTcEfktqgp0Tq
 MRZeWNtZdAwPaBLp4d1s0QzZRvZn2xU4XunEkpj/qvGdb2vRp3
 Jg9rGcgRqWuoXvGHLCDqeXt6HbGjvdeo8XbPgNiMH7xPEUqZqF
 Dt/MesrayFWr8ccFeHLY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 11:15:20 Maxime Ripard wrote:
> 
> > One of the problems with the current interface is that it requires
> > statically declaring platform_device structures, which is something
> > that has been on Greg's list of device model antipatterns for a long
> > time.
> 
> I didn't find any difference with how you declare platform_devices
> compared to the old-usual way in board files, or was it something on
> the list too ? 

Yes. We never really bothered with cleaning up the existing static
platform_device instances, because the plan is to move away from
board files to DT anyway, but in short, if you ever need to add
a platform device to a legacy board file, do it like

	pdev = platform_device_alloc(...);
	platform_device_register(dev);

or

	platform_device_register_simple(...);

or

	static const struct platform_device_info info __initconst = { ... };
	platform_device_register_full(&info);

but not

	static struct platform_device pdev = { ... };
	platform_device_register(&pdev);

Unfortunately, the early platform_device only allows the last type.

	Arnd
