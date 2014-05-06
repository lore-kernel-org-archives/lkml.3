Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaEFMWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:22:25 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:50297 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053AbaEFMWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:22:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-usb@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Mathias Nyman <mathias.nyman@intel.com>, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Nadav Haklai <nadavh@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 06/20] usb: host: xhci-plat: Add support for the Armada 38x
Date: Tue, 06 May 2014 14:21:55 +0200
Message-ID: <4660313.evfclGtT1x@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140506141023.715b932d@skate>
References: <1399335255-589-1-git-send-email-gregory.clement@free-electrons.com> <61061197.hLhKsFqJLF@wuerfel> <20140506141023.715b932d@skate>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cxj2o8RS5oXpVjiHol0ts34yUK5WdvxTDuSqGMaQnhb
 l18r+wuRhZbwAz0e6CITqUtTqY3QB3pj8T97aL/thqzLNt2Ohh
 zT8Sn/CmXCzXjYb78y3Ptk+WCcH83jV3pzV9d3U381T+Y1y0OJ
 EQRPC4KnS5zEqIv72P77+6Kkoi7tByX4mnPB8xpe3Z4YWTCfI+
 3o1H8UYBtRGr7QWKwW0LRF79Jf/qphUkmR8c8ehCcXcON0z2vp
 IVfBQTAW4P7rq4N6N9bP7Ib/a+Do8QSVgcf0fuM6r1K+Ikf58/
 +mhoVBjRZ3x6WB4R5sK9jyxfG4VfsNS2l+Zo6nnKwq7gQoJTlA
 NotpHFMq7SFWdm2XMR90=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 May 2014 14:10:23 Thomas Petazzoni wrote:
> On Tue, 06 May 2014 13:57:44 +0200, Arnd Bergmann wrote:
> 
> > > Please limit this driver to mvebu arch and compile testing, i.e.
> > > 
> > >         depends on ARCH_MVEBU || COMPILE_TEST
> > 
> > I think it actually needs a dependency on MVEBU_MBUS.
> 
> That's not what we do for any of the other drivers that use the
> MVEBU_MBUS functions.

Fair enough. I guess using ARCH_MVEBU as the dependency works as well
because it implies MVEBU_MBUS. However, you can't use COMPILE_TEST
then because the driver itself needs the interfaces provided by MBUS.

It could be

	depends on ARCH_MVEBU || (MVEBU_MBUS && COMPILE_TEST)

to describe the dependency most accurately.

> > You probably need something like
> > 
> >       depends on MVEBU_MBUS=y || (MVEBU_MBUS=m && USB_XHCI=m)
> 
> MVEBU_MBUS is a bool, so there is no way is can be =m.

Yes, that helps.

	Arnd
