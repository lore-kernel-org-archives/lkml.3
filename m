Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaIBIF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:05:28 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47857 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaIBIFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:05:23 -0400
Date: Tue, 2 Sep 2014 09:05:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, naushad@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, linux-samsung-soc@vger.kernel.org,
        broonie@kernel.org, thomas.ab@samsung.com, vikas.sajjan@samsung.com,
        chow.kim@samsung.com
Subject: Re: [PATCH] mfd: syscon: Decouple syscon interface from syscon
 devices
Message-ID: <20140902080516.GE17117@lee--X1>
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com>
 <12348292.z1qJl96tVA@wuerfel>
 <20140901160426.GJ8796@lee--X1>
 <3343901.7HpqcTBEp1@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3343901.7HpqcTBEp1@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Arnd Bergmann wrote:

> On Monday 01 September 2014 17:04:26 Lee Jones wrote:
> > On Mon, 01 Sep 2014, Arnd Bergmann wrote:
> > > Maybe I'm misreading the patch, but I don't see how it creates a
> > > migration path. What I want to end up with is infrastructure that
> > > lets anybody call syscon_regmap_lookup_by_pdevname or
> > > syscon_regmap_lookup_by_compatible (if they really need to)
> > > without needing the platform_driver for syscon. That should not
> > > require any form of compatibility layer because to the driver
> > > using it there is no API change.
> > 
> > Somehow I think the likelyhood is that I am misreading the patch.
> > 
> > I thought that before this patch drivers we had to register a syscon
> > device to bind to this driver, which was fine for the first use-cases
> > of syscon as it wasn't required too early during boot.  However, now
> > there are use-cases where systems require access to syscon registers
> > eariler in boot we require a means to obtain access prior to device
> > probing.  I thought this patch not only provides that possibilty, but
> > also leaves in the ability to register direct from DT.
> 
> Right, it does provide the ability to have syscon before devices
> are registered, I missed that part.
> 
> > > In contrast, this patch introduces a new of_syscon_{un,}register()
> > > interface that would get removed after the the above has
> > > been implemented, causing extra churn for any driver that also
> > > wants to provide a regmap-like interface.
> > 
> > When will we ever not have to register syscon?
> 
> The idea is that we implicitly register the syscon block when someone
> calls syscon_regmap_lookup_by_compatible or syscon_regmap_lookup_by_phandle
> and then return a reference to that new syscon. When another driver
> looks up the same device node, we just pass a reference to the existing
> syscon.

Doesn't sound too unreasonable.  So how about instead of exporting
these new of_syscon_{un,}register() calls, we make them static and
call them from syscon_regmap_lookup_by_{phandle,compatible}?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
