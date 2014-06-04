Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaFDVMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:12:20 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52491 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751094AbaFDVMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:12:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        wsa@the-dreams.de, grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: Re: [PATCH 1/7] ACPICA: Only include ACPI asm files if ACPI is enabled
Date: Wed, 04 Jun 2014 23:29:33 +0200
Message-ID: <1603851.9SBouhvdWS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140604125137.GA18171@lee--X1>
References: <1401883796-17841-1-git-send-email-lee.jones@linaro.org> <3061297.feg5DGUjIt@vostro.rjw.lan> <20140604125137.GA18171@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 04, 2014 01:51:37 PM Lee Jones wrote:
> On Wed, 04 Jun 2014, Rafael J. Wysocki wrote:
> 
> > On Wednesday, June 04, 2014 01:09:50 PM Lee Jones wrote:
> > > Any drivers which support ACPI and Device Tree probing need to include
> > > both respective header files.  Without this patch, if a driver is being
> > > used on a platform which does not support ACPI and subsequently does not
> > > have the config option enabled, but includes linux/acpi.h the build
> > > breaks with:
> > > 
> > >   In file included from ../include/acpi/platform/acenv.h:150:0,
> > >                    from ../include/acpi/acpi.h:56,
> > >                    from ../include/linux/match.h:2,
> > >                    from ../drivers/i2c/i2c-core.c:43:
> > >   ../include/acpi/platform/aclinux.h:73:23:
> > >    fatal error: asm/acenv.h: No such file or directory
> > >    #include <asm/acenv.h>
> > >                        ^
> > 
> > Which kernel does this happen with?
> 
> a0a962d (tag: refs/tags/next-20140602, refs/remotes/next/master)
>   Add linux-next specific files for 20140602

It looks like the problem is with include/linux/match.h that should not
include acpi/acpi.h directly.

But I can't find this file in the Linus' next branch even, so I guess it's
on its way to that branch?

Rafael

