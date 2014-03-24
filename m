Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaCXLip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:38:45 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:39978 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752454AbaCXLim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:38:42 -0400
Date: Mon, 24 Mar 2014 11:38:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>, "x86@kernel.org" <x86@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 7/8] tty/serial: add arm64 semihosting earlycon
Message-ID: <20140324113821.GF3850@arm.com>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
 <1395436128-11244-8-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395436128-11244-8-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 09:08:47PM +0000, Rob Herring wrote:
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 81bdd52..e96e2ba 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -888,6 +888,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  		uart[8250],mmio,<addr>[,options]
>  		uart[8250],mmio32,<addr>[,options]
>  		pl011,<addr>
> +		smh
>  			Start an early, polled-mode console on a serial port
>  			at the specified I/O port or MMIO address. 8250
>  			MMIO inter-register address stride is either 8-bit

Same comment as per a previous patch, "smh" does not take any parameters
at all here.

> --- /dev/null
> +++ b/drivers/tty/serial/earlycon-arm-semihost.c
> @@ -0,0 +1,44 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + * Author: Catalin Marinas <catalin.marinas@arm.com>

Nitpick: author should be Mark Zyngier <marc.zyngier@arm.com> as per
commit 0492f72508184 (arm64: early_printk: add support for FastModel
console output)

-- 
Catalin
