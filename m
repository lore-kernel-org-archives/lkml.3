Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934488Ab3CHRSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:18:44 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57118 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933088Ab3CHRSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:18:42 -0500
Message-ID: <1362763120.5994.73.camel@x61.thuisdomein>
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
From: Paul Bolle <pebolle@tiscali.nl>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 18:18:40 +0100
In-Reply-To: <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
References: <1362738596.5994.48.camel@x61.thuisdomein>
	 <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 17:18:40.0293 (UTC) FILETIME=[FA398D50:01CE1C20]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-08 at 18:11 +0200, Aaro Koskinen wrote:
> On Fri, Mar 08, 2013 at 11:29:56AM +0100, Paul Bolle wrote:
> > When support was added for Nokia N9 (RM-696), with commit
> > 63fc5f3bb3d0ca9ab4767a801b518aa6335f87ad ("ARM: OMAP: add minimal
> > support for Nokia RM-696"), a select statement for MACH_NOKIA_RM696 was
> > added to the tree. But there's no Kconfig symbol with that name. That
> > symbol would be superfluous, since support for that machine piggybacks
> > on MACH_NOKIA_RM680. So drop that select.
> 
> This is needed because of arch/arm/tools/mach-types. See
> include/generated/mach-types.h.

How does that file actually need this select statement?

> If you have just CONFIG_MACH_NOKIA_RM680 and run the kernel on RM-696,
> then machine_is_nokia_rm696() will return false. If I rememeber correctly,
> this broke at least early printk / uncompressor output at the time.
> 
> I guess people may still want to use machine_is_... macros e.g. for
> debugging.

What in the current mainline kernel cares about a
machine_is_nokia_rm696() macro?
    $ git grep -n machine_is_nokia v3.9-rc1
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:349:  if (machine_is_nokia_n800() || slot == 0)
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:395:  if (machine_is_nokia_n800()) {
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:428:  if (machine_is_nokia_n800())
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:451:  if (machine_is_nokia_n800()) {
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:478:  if (machine_is_nokia_n800())
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:493:  if (machine_is_nokia_n810()) {
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:544:  if (machine_is_nokia_n810()) {
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:562:  if (machine_is_nokia_n810()) {
    v3.9-rc1:arch/arm/mach-omap2/board-n8x0.c:714:  if (machine_is_nokia_n810())
    v3.9-rc1:arch/arm/mach-omap2/board-rx51-video.c:71:     if (!machine_is_nokia_rx51())
    v3.9-rc1:drivers/usb/host/ohci-omap.c:267:      } else if (machine_is_nokia770()) {
    v3.9-rc1:sound/soc/omap/n810.c:309:     if (!(machine_is_nokia_n810() || machine_is_nokia_n810_wimax()))
    v3.9-rc1:sound/soc/omap/rx51.c:400:     if (!machine_is_nokia_rx51())

    $ git grep -n rm696 v3.9-rc1
    v3.9-rc1:arch/arm/tools/mach-types:589:nokia_rm696		MACH_NOKIA_RM696	NOKIA_RM696		3522

I don't find any actual usage of that macro. Are its uses also
generated? 

> > 0) Tested with "git grep".
> 
> git grep won't search generated source files.

Of course. That's one of the reasons why I explicitly state that I only
tested it that way.

> > 1) Some searching on the web didn't return a "config MACH_NOKIA_RM696".
> > So apparently there's not even a development tree that uses this symbol.
> 
> You can see machine_is_nokia_rm696() used in the public kernel source
> for Nokia N9 product. :-)

Where would that be? And does that tree actually have a Kconfig entry
MACH_NOKIA_RM696?


Paul Bolle

