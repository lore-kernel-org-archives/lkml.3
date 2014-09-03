Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaICOPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 10:15:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46532 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755817AbaICOPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 10:15:31 -0400
Date: Wed, 3 Sep 2014 16:15:28 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, Alexander Shiyan <shc_work@mail.ru>,
        naushad@samsung.com, Tomasz Figa <t.figa@samsung.com>,
        linux-kernel@vger.kernel.org, joshi@samsung.com,
        linux-samsung-soc@vger.kernel.org, thomas.ab@samsung.com,
        tomasz.figa@gmail.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        lee.jones@linaro.org, Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v2] mfd: syscon: Decouple syscon interface from platform
 devices
Message-ID: <20140903161528.05f566e1@bbrezillon>
In-Reply-To: <4224773.hl3QDeILqz@wuerfel>
References: <1409668935-10667-1-git-send-email-pankaj.dubey@samsung.com>
	<6034841.GFrG3XCMdb@wuerfel>
	<20140903151611.260a7218@bbrezillon>
	<4224773.hl3QDeILqz@wuerfel>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Sep 2014 15:49:04 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 03 September 2014 15:16:11 Boris BREZILLON wrote:
> > I checked that part, and it appears most of the code is already there
> > (see usage of regmap_attach_dev function here [1]).
> > 
> > The only problem I see is that errors are still printed with dev_err,
> > which, AFAIK, will trigger a kernel panic if dev is NULL.
> 
> Actually not:
> 
> static int __dev_printk(const char *level, const struct device *dev,
>                         struct va_format *vaf)
> {
>         if (!dev)
>                 return printk("%s(NULL device *): %pV", level, vaf);
> 
>         return dev_printk_emit(level[1] - '0', dev,
>                                "%s %s: %pV",
>                                dev_driver_string(dev), dev_name(dev), vaf);
> }
> 

My bad then (I don't know where I looked at to think NULL dev was not
gracefully handled :-)). Thanks for pointing this out.
Given that, I think it should work fine even with a NULL dev.
I'll give it a try on at91 ;-).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
