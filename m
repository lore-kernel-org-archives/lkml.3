Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab3ARTE4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:04:56 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:56543 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3ARTEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:04:55 -0500
Date: Fri, 18 Jan 2013 20:04:52 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 31/76] ARC: Build system: Makefiles, Kconfig, Linker
	script
Message-ID: <20130118190452.GA14433@merkur.ravnborg.org>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-32-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358511930-7424-32-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#
> +
> +config ARC
> +	def_bool y
> +	select ARCH_NO_VIRT_TO_BUS
> +	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
> +	# DEVTMPS in turn needs HOTPLUG
> +	select DEVTMPFS if !INITRAMFS_SOURCE=""
> +	select GENERIC_ATOMIC64
> +	select GENERIC_CLOCKEVENTS
> +	select GENERIC_FIND_FIRST_BIT
> +	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
> +	select GENERIC_IRQ_SHOW
> +	select GENERIC_PENDING_IRQ if SMP
> +	select GENERIC_SMP_IDLE_THREAD
> +	select HAVE_GENERIC_HARDIRQS
> +	select HOTPLUG if !INITRAMFS_SOURCE=""

HOTPLUG is alwyas y now.

> +# Hacks to enable final link due to absence of link-time branch relexation
> +# and gcc choosing optimal(shorter) branches at -O3
> +#
> +# vineetg Feb 2010: -mlong-calls switched off for overall kernel build
> +# However lib/decompress_inflate.o (.init.text) calls
> +# zlib_inflate_workspacesize (.text) causing relocation errors.
> +# Thus forcing all exten calls in this file to be long calls
> +export CFLAGS_decompress_inflate.o = -mmedium-calls
> +export CFLAGS_initramfs.o = -mmedium-calls
This is gross..
But I see no better way to do this for now.

> +++ b/arch/arc/kernel/Makefile
> @@ -0,0 +1,16 @@
> +#
> +# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
> +#
> +# This program is free software; you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License version 2 as
> +# published by the Free Software Foundation.
> +
> +obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
> +	   signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o

For new stuff I usually recommend to drop line continuation using \

Just do the much prettier:
obj-y := arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o
obj-y += signal.o traps.o sys.o troubleshoot.o stacktrace.o clk.o

> +++ b/arch/arc/lib/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
> +#
> +# This program is free software; you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License version 2 as
> +# published by the Free Software Foundation.
> +
> +lib-y	:= strchr-700.o strcmp.o strcpy-700.o strlen.o \
> +	   memcmp.o memcpy-700.o memset.o

Avoid '\'

> diff --git a/arch/arc/mm/Makefile b/arch/arc/mm/Makefile
> new file mode 100644
> index 0000000..9e2c1ca
> --- /dev/null
> +++ b/arch/arc/mm/Makefile
> @@ -0,0 +1,10 @@
> +#
> +# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
> +#
> +# This program is free software; you can redistribute it and/or modify
> +# it under the terms of the GNU General Public License version 2 as
> +# published by the Free Software Foundation.
> +#
> +
> +obj-y	:= extable.o ioremap.o dma.o fault.o init.o \
> +	   tlb.o tlbex.o cache_arc700.o
Avoid '\'

Other these small nits I did not notice anything.
General impression is that this looks good!

	Sam
