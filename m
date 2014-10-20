Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaJTNgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:36:23 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:49303 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbaJTNgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:36:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <josh.cartwright@ni.com>, monstr@monstr.eu,
        Russell King <linux@arm.linux.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH v2 1/3] ARM: zynq: Move common.h to generic location
Date: Mon, 20 Oct 2014 15:36:06 +0200
Message-ID: <3225036.9QQDRKvzZS@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com>
References: <742a19eb987f3f99b42ba4b7e7ebc27bf19d7d72.1413811526.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:PpeMchHIVKakIRPv4pb0ocUPcs51L7iI7afmEJenDhe
 e7K1Iy0N2ZoDLhh1oio1EnYTYx8F/a6vmFj5KySI5WNnG+7bZF
 zYmUsI/+BZNYzYYaGf4dUKDcbFXYfMDG5oc7ndNHSxUuxX35O/
 oO+dq0qbH1OdSh+sblGR/Vz2KgCDqO2RpZaI3d2bDFK19NhrWi
 7AERKuJbqpcNDw6IgaQY+bu03dVcstcGQ0qQA5Omxs+mjxCXFH
 6tqRU3IHZjFaA6GIK6Y9bzdRDz82ywa71lT8hHdLq2B01khF6h
 /X/GNhTPAPJjPKdSuSHMLJIT0D3Zoan6WAy6Y4yHUwzyxfEt5N
 yoUx8uEGear6gAWkQjXo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 October 2014 15:25:31 Michal Simek wrote:
> include/soc/zynq/ is the right location for this header
> to be able to share information from this header with other
> drivers which require it.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> ---
> 
> Changes in v2:
> - Update pm.c added in 3.17 too - Soren pointed on it
> 
>  arch/arm/mach-zynq/common.c                       |  2 +-
>  arch/arm/mach-zynq/hotplug.c                      | 14 --------------
>  arch/arm/mach-zynq/platsmp.c                      |  2 +-
>  arch/arm/mach-zynq/pm.c                           |  2 +-
>  arch/arm/mach-zynq/slcr.c                         |  2 +-
>  {arch/arm/mach-zynq => include/soc/zynq}/common.h |  0
>  6 files changed, 4 insertions(+), 18 deletions(-)
>  delete mode 100644 arch/arm/mach-zynq/hotplug.c
>  rename {arch/arm/mach-zynq => include/soc/zynq}/common.h (100%)
> 

NAK

Most (if not all) of that header should not be visible to drivers.
If you need to share some symbols, make a proper header file for those,
not one called 'common.h'.

	Arnd
