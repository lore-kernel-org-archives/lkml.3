Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829Ab3CHQME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:12:04 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:34370 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759692Ab3CHQMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:12:02 -0500
Date: Fri, 8 Mar 2013 18:11:59 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: drop "select MACH_NOKIA_RM696"
Message-ID: <20130308161159.GE14552@blackmetal.musicnaut.iki.fi>
References: <1362738596.5994.48.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362738596.5994.48.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 11:29:56AM +0100, Paul Bolle wrote:
> When support was added for Nokia N9 (RM-696), with commit
> 63fc5f3bb3d0ca9ab4767a801b518aa6335f87ad ("ARM: OMAP: add minimal
> support for Nokia RM-696"), a select statement for MACH_NOKIA_RM696 was
> added to the tree. But there's no Kconfig symbol with that name. That
> symbol would be superfluous, since support for that machine piggybacks
> on MACH_NOKIA_RM680. So drop that select.

This is needed because of arch/arm/tools/mach-types. See
include/generated/mach-types.h.

If you have just CONFIG_MACH_NOKIA_RM680 and run the kernel on RM-696,
then machine_is_nokia_rm696() will return false. If I rememeber correctly,
this broke at least early printk / uncompressor output at the time.

I guess people may still want to use machine_is_... macros e.g. for
debugging.

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> 0) Tested with "git grep".

git grep won't search generated source files.

> 1) Some searching on the web didn't return a "config MACH_NOKIA_RM696".
> So apparently there's not even a development tree that uses this symbol.

You can see machine_is_nokia_rm696() used in the public kernel source
for Nokia N9 product. :-)

A.
