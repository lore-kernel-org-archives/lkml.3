Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab3KRNG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:06:27 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:38840 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3KRNGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:06:24 -0500
Date: Mon, 18 Nov 2013 13:06:16 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Constify struct mfd_cell where possible
Message-ID: <20131118130616.GI13640@lee--X1>
References: <1384779449-1888-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384779449-1888-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Geert Uytterhoeven wrote:

> As of commit 03e361b25ee8dfb1fd9b890072c23c4aae01c6c7 ("mfd: Stop setting
> refcounting pointers in original mfd_cell arrays"), the "cell" parameter of
> mfd_add_devices() is "const" again. Hence make all cell data passed to
> mfd_add_devices() const where possible.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> Compile tested:
>   - cs5535-mfd, intel_msic, and sta2x11-mfd for x86,
>   - all other drivers for arm.
> 
>  drivers/mfd/88pm800.c             |    4 ++--
>  drivers/mfd/88pm805.c             |    2 +-
>  drivers/mfd/ab8500-core.c         |   14 +++++++-------
>  drivers/mfd/arizona-core.c        |    8 ++++----
>  drivers/mfd/as3722.c              |    2 +-
>  drivers/mfd/asic3.c               |    4 ++--
>  drivers/mfd/cros_ec.c             |    2 +-
>  drivers/mfd/da9052-core.c         |    2 +-
>  drivers/mfd/da9055-core.c         |    2 +-
>  drivers/mfd/da9063-core.c         |    2 +-
>  drivers/mfd/db8500-prcmu.c        |    4 ++--
>  drivers/mfd/htc-pasic3.c          |    2 +-
>  drivers/mfd/intel_msic.c          |    2 +-
>  drivers/mfd/jz4740-adc.c          |    2 +-
>  drivers/mfd/lp8788.c              |    2 +-
>  drivers/mfd/max77686.c            |    2 +-
>  drivers/mfd/max77693.c            |    2 +-
>  drivers/mfd/max8907.c             |    2 +-
>  drivers/mfd/max8925-core.c        |    8 ++++----
>  drivers/mfd/max8997.c             |    2 +-
>  drivers/mfd/max8998.c             |    4 ++--
>  drivers/mfd/rc5t583.c             |    2 +-
>  drivers/mfd/rdc321x-southbridge.c |    2 +-
>  drivers/mfd/retu-mfd.c            |    6 +++---
>  drivers/mfd/sec-core.c            |    8 ++++----
>  drivers/mfd/stmpe.c               |   10 +++++-----
>  drivers/mfd/stmpe.h               |    2 +-
>  drivers/mfd/tc3589x.c             |    4 ++--
>  drivers/mfd/tc6387xb.c            |    2 +-
>  drivers/mfd/timberdale.c          |   12 ++++++------
>  drivers/mfd/tps6507x.c            |    2 +-
>  drivers/mfd/tps65090.c            |    2 +-
>  drivers/mfd/tps65217.c            |    2 +-
>  drivers/mfd/tps6586x.c            |    2 +-
>  drivers/mfd/tps65910.c            |    2 +-
>  drivers/mfd/tps65912-core.c       |    2 +-
>  drivers/mfd/tps80031.c            |    2 +-
>  drivers/mfd/viperboard.c          |    2 +-
>  drivers/mfd/vx855.c               |    2 +-
>  drivers/mfd/wm831x-core.c         |   14 +++++++-------
>  drivers/mfd/wm8994-core.c         |    4 ++--
>  drivers/staging/nvec/nvec.c       |    2 +-
>  42 files changed, 80 insertions(+), 80 deletions(-)

In the interests of bisectability and revertability, I'd prefer one
patch per file-change where possible please. Or at the very least in
groups of files, so one for tps*, another one for max*, etc.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
