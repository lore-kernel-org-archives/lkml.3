Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbaGQLZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:25:24 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53997 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaGQLZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:25:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Weinberger <richard@nod.at>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Guenter Roeck <linux@roeck-us.net>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmitry.torokhov@gmail.com, linux-iio@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, teg@jklm.no,
        Thierry Reding <thierry.reding@gmail.com>,
        Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Liqin Chen <liqin.linux@gmail.com>, msalter@redhat.com,
        linux-pwm@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        knaack.h@gmx.de, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mischa.Jonker@synopsys.com, jic23@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for 'devm_ioremap_resource'
Date: Thu, 17 Jul 2014 13:24:46 +0200
Message-ID: <5581945.I7Fc5qufcE@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C7AC6F.1070001@nod.at>
References: <201407130545.23004.marex@denx.de> <8453588.VVyODXRso0@wuerfel> <53C7AC6F.1070001@nod.at>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:v3ic0lEx5zJKotoQtSyH8IFw7otQyEmDN4naYX6rAd3
 ukHDOB64CUmyMMGtW3GqVQ0I+ksq/duZZzZVi1ZzVrziGQoGOb
 wcqOLUItePB3LlG/73Or/D7239YLXDkPLr3Tr+ct5+Nl+8TTW2
 Tf/UCsAorXKM3F8X8YT+K2uAD258D18dbNeq0m+M76ELUegPHk
 dxVRzAZB30GdtaFu40f+KkI+n6gdR1hMugT/8y2RF0uHFpc3zI
 hNsOAHtBF+Wz+OvUt3ERJjRRpuP6POfo9eURy/zef5t6/J3nJi
 O0TH+/14ulFCHMJkCmWRm9iRvxLzv9A5F7r+UZYtKmTiAnKNfO
 E6C8Cf8R1wTJ73zl1W0s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 July 2014 12:58:55 Richard Weinberger wrote:
> > This is what I got upon trying earlier. I have not attempted to look into
> > why this is happening. Note this is on linux-next from yesterday,
> > not mainline as I incorrectly stated above.
> > 
> > In file included from ../arch/um/include/asm/fixmap.h:58:0,
> >                  from ../arch/um/include/asm/pgtable.h:11,
> >                  from ../include/linux/mm.h:51,
> >                  from ../kernel/uid16.c:6:
> > ../include/asm-generic/fixmap.h: In function 'fix_to_virt':
> > ../include/asm-generic/fixmap.h:31:2: error: size of unnamed array is negative
> >   BUILD_BUG_ON(idx >= __end_of_fixed_addresses);
> 
> So, this is next-20140716?
> I don't see the fixmap issue you're reporting, also not on the most recent next.

Sorry, nevermind. I had a workaround for a gcc-4.9 bug applied that
turned off optimization for uid16.c, which fixed the build for ARM for
me but happened to break x86 including uml.

Without that patch, I don't see this problem.

	Arnd
