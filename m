Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaJ1OFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:05:46 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47235 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751189AbaJ1OFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:05:45 -0400
Date: Tue, 28 Oct 2014 14:05:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: arm@kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 5/5] ARM: use early console instead of early debug in
 allmodconfig kernels
Message-ID: <20141028140536.GF27405@n2100.arm.linux.org.uk>
References: <1414503095-25986-1-git-send-email-kaixu.xia@linaro.org>
 <1414503095-25986-6-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414503095-25986-6-git-send-email-kaixu.xia@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 09:31:35PM +0800, Xia Kaixu wrote:
> The early debug could break something when booting 'allmodconfig'
> kernels. So we use early console instead of early debug.
> 
> The early console didn't work yet on OMAP4460 because of missing
> earlycon support and I am working on that.

No. bloody. way.

> @@ -78,7 +78,7 @@ config DEBUG_USER
>  # These options are only for real kernel hackers who want to get their hands dirty.
>  config DEBUG_LL
>  	bool "Kernel low-level debugging functions (read help!)"
> -	depends on DEBUG_KERNEL
> +	depends on DEBUG_KERNEL && !ARCH_MULTIPLATFORM_STRICT

Firstly, this is well advertised that it can only be applied to a single
configuration.  So I don't think we need this dependency here.  Even if
you want to build a strict multiplatform kernel, it should still be
possible to enable this for a specific platform.

It's a developer option, one which requires the developer to engage their
brain before using.

> @@ -1297,6 +1297,29 @@ config EARLY_PRINTK
>  	  kernel low-level debugging functions. Add earlyprintk to your
>  	  kernel parameters to enable this console.
>  
> +config FORCE_EARLY_CONSOLE
> +	bool "Enable all early console drivers"
> +	depends on DEBUG_KERNEL && ARCH_MULTIPLATFORM_STRICT
> +	select TTY
> +	select SERIAL_8250
> +	select SERIAL_8250_CONSOLE
> +	select SERIAL_AMBA_PL011
> +	select SERIAL_AMBA_PL011_CONSOLE
> +	select SERIAL_EARLYCON_ARM_SEMIHOST
> +	select SERIAL_MSM
> +	select SERIAL_MSM_CONSOLE
> +	select SERIAL_XILINX_PS_UART
> +	select SERIAL_XILINX_PS_UART_CONSOLE

Not only will this be a for-ever expanding list, but it'll also continually
suffer from various problems with dependencies.  I absolutely *HATE* the
idea of selecting user visible options like this.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
