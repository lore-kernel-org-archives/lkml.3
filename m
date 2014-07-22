Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaGVKcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:32:22 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:56664 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504AbaGVKcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:32:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>, Richard Weinberger <richard@nod.at>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tom Gundersen <teg@jklm.no>, Thierry Reding <thierry.reding@gmail.com>,
        Marek Vasut <marex@denx.de>, Liqin Chen <liqin.linux@gmail.com>,
        msalter@redhat.com, linux-pwm@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        jic23@kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        cmetcalf@tilera.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for 'devm_ioremap_resource'
Date: Tue, 22 Jul 2014 12:32:06 +0200
Message-ID: <179292068.QXZf3Zcqzf@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53CB8FC4.4050009@gmail.com>
References: <201407130545.23004.marex@denx.de> <53CB801D.1030603@gmail.com> <53CB8FC4.4050009@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:uLqhMdIEHgv9s9/bqRpHd15jqnzFtwmYP0sbJVL9RTJ
 cHpXUflY0BHMVgfqbH0xgzvjwrTm6b5sfU10+hIBNcz2b0mgkA
 2z+TUNamIOB9nlGUg+8mWgsz9wNFFB26c+xgGsmnonhfW6tv8f
 75eCoAYxNktXMNC3plnYIVf3r7rJ1cqin4KLMAV7DQiAK2oyNS
 MxxX8T+oWwJ4UYgpqfGspbppvVxAvv4VTZmEWc4U8MiXFq6ryZ
 gpvWHOpi4984qbcyr9KJERr3oa1SlW6zEP8nJ/AAlRtymz5ZIK
 UWmUMy9jndA1qwuNiD2AICh2RUi97BtjQEAxKJCfHbSPvSZMxj
 LrgKPVlU1uA8f6siBn3M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 July 2014 17:45:40 Chen Gang wrote:
> > 
> > Next, I shall:
> > 
> >  - Remove HAS_IOMEM and NO_IOMEM from kernel, firstly.
> > 
> >  - Try to make dummy IOMEM functions for score architecture.
> > 
> >  - Continue discussing with UML for it.
> >
>  
> Oh, sorry, I forgot, after remove IOMEM from kernel, also s390 and tile
> need implement dummy IOMEM if !PCI.
> 
> If possible, I shall try to implement the dummy IOMEM in 'asm-generic',
> and let uml, score, s390 and tile use them when they need.

Sorry for going round in circles, but looking back at the original patches,
adding the extra 'depends on HAS_IOMEM' does seem much better than the
other suggestions that came afterwards.

In particular, removing HAS_IOMEM and NO_IOMEM sounds like an awful idea
to me. I'd rather add a HAS_IOPORT in addition to also catch architectures
that have no support for PC-style PIO.

	Arnd

