Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaENO0x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:26:53 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:54624 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbaENO0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:26:52 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 0/6] DT early console initialization
To: Rob Herring <robherring2@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: benh@kernel.crashing.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh@kernel.org>
In-Reply-To: <1399587823-17701-1-git-send-email-robherring2@gmail.com>
References: <1399587823-17701-1-git-send-email-robherring2@gmail.com>
Date: Wed, 14 May 2014 15:26:44 +0100
Message-Id: <20140514142644.1C922C4153D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  8 May 2014 17:23:37 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
> 
> This series adds support for early serial console initialization using 
> DT. This enables determining the serial port type and address using the 
> FDT and allows enabling the console before platform specific 
> initialization runs. I've tested this on arm64. ARM support is dependent 
> on adding fixmap support.
> 
> Currently, the earlycon is only enabled if "earlycon" is present on the 
> kernel command line. The FDT needs to have /chosen/stdout-path set to 
> the path of the serial port.
> 
> This series is dependent on generic earlycon[1], libfdt support[2], and 
> vmlinux.lds.h clean-ups[3]. The first 2 are in linux-next already. A git 
> branch is available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git earlycon-dt

Nice. For the whole series:

Acked-by: Grant Likely <grant.likely@linaro.org>

I haven't tested it though.

> 
> Rob
> 
> [1] https://lkml.org/lkml/2014/4/18/573
> [2] https://lkml.org/lkml/2014/4/22/1202
> [3] https://lkml.org/lkml/2014/3/27/285
> 
> Rob Herring (6):
>   of: align RESERVEDMEM_OF_DECLARE function callbacks to other callbacks
>   of: consolidate linker section OF match table declarations
>   serial: earlycon: add DT support
>   of/fdt: add FDT address translation support
>   of/fdt: add FDT serial scanning for earlycon
>   tty/serial: pl011: add DT based earlycon support
> 
>  drivers/clocksource/clksrc-of.c   |   2 +-
>  drivers/irqchip/irqchip.h         |   7 +-
>  drivers/of/Makefile               |   2 +
>  drivers/of/fdt.c                  |  56 +++++++++
>  drivers/of/fdt_address.c          | 241 ++++++++++++++++++++++++++++++++++++++
>  drivers/of/of_reserved_mem.c      |   2 +-
>  drivers/tty/serial/amba-pl011.c   |   1 +
>  drivers/tty/serial/earlycon.c     |  27 +++++
>  include/asm-generic/vmlinux.lds.h |   4 +-
>  include/linux/clk-provider.h      |   5 +-
>  include/linux/clocksource.h       |  16 +--
>  include/linux/of.h                |  22 ++++
>  include/linux/of_fdt.h            |   1 +
>  include/linux/of_reserved_mem.h   |  22 +---
>  include/linux/serial_core.h       |   6 +
>  15 files changed, 372 insertions(+), 42 deletions(-)
>  create mode 100644 drivers/of/fdt_address.c
> 
> -- 
> 1.9.1
> 

