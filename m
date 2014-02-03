Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaBCWkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:40:17 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:54194 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaBCWkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:40:16 -0500
MIME-Version: 1.0
X-Originating-IP: [89.242.63.23]
In-Reply-To: <1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
	<1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
Date: Mon, 3 Feb 2014 22:34:40 +0000
Message-ID: <CAPcvp5EF_=G=VwWLfbw6mwczErTHeq4AbVALYpuAzb3c5eb2rA@mail.gmail.com>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
From: Andrew Murray <amurray@embedded-bits.co.uk>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 February 2014 18:43, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 4cc813e..ce5bad2 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -120,9 +120,13 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
>  /*
>   *  I/O port access primitives.
>   */
> +#define arch_has_dev_port()    (0)
>  #define IO_SPACE_LIMIT         0xffff
>  #define PCI_IOBASE             ((void __iomem *)(MODULES_VADDR - SZ_2M))
>
> +#define ioport_map(port, nr)   (PCI_IOBASE + ((port) & IO_SPACE_LIMIT))
> +#define ioport_unmap(addr)

I'm not sure that this will work. The in[bwl], out[bwl] macros in
arch/arm64/include/asm/io.h already add the PCI_IOBASE offset.

Instead of these two #defines, why not just enforce that
GENERIC_PCI_IOMAP is enabled? Or at least wrap these defines with 'if
(!config_enabled(CONFIG_GENERIC_PCI_IOMAP))' or similar.

> +
>  static inline u8 inb(unsigned long addr)
>  {
>         return readb(addr + PCI_IOBASE);


Andrew Murray
