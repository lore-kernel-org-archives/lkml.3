Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaCXLW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:22:26 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:34419 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752719AbaCXLWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:22:24 -0400
Date: Mon, 24 Mar 2014 11:22:03 +0000
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
Subject: Re: [PATCH 4/8] tty/serial: add generic serial earlycon
Message-ID: <20140324112203.GD3850@arm.com>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com>
 <1395436128-11244-5-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395436128-11244-5-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 09:08:44PM +0000, Rob Herring wrote:
> diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
> new file mode 100644
> index 0000000..241757a
> --- /dev/null
> +++ b/drivers/tty/serial/earlycon.c
[...]
> +static void __iomem * __init earlycon_map(unsigned long paddr, size_t size)
> +{
> +	void __iomem *base;
> +#ifdef CONFIG_FIX_EARLYCON_MEM
> +	set_fixmap_nocache(FIX_EARLYCON_MEM_BASE, paddr & PAGE_MASK);
> +	base = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
> +	base += paddr & ~PAGE_MASK;
> +#else
> +	base = ioremap_nocache(paddr, size);
> +#endif

Just curious why not set_fixmap_io (and plain ioremap)?

> +static int __init parse_options(struct earlycon_device *device,
> +				char *options)
> +{
[...]
> +	if (port->mapbase)
> +		port->membase = earlycon_map(port->mapbase, 64);

I would move the earlycon_map() call in setup_earlycon() (personal
preference, parse_options() implies just parsing the options rather than
having additional side-effects).

-- 
Catalin
