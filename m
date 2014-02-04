Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbaBDM34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:29:56 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39956 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbaBDM3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:29:55 -0500
Date: Tue, 4 Feb 2014 12:29:51 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Andrew Murray <amurray@embedded-bits.co.uk>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] arm64: Add architecture support for PCI
Message-ID: <20140204122951.GC27975@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Andrew Murray <amurray@embedded-bits.co.uk>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Arnd Bergmann <arnd@arndb.de>
References: <1391453028-23191-1-git-send-email-Liviu.Dudau@arm.com>
 <1391453028-23191-2-git-send-email-Liviu.Dudau@arm.com>
 <CAPcvp5EF_=G=VwWLfbw6mwczErTHeq4AbVALYpuAzb3c5eb2rA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcvp5EF_=G=VwWLfbw6mwczErTHeq4AbVALYpuAzb3c5eb2rA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 04 Feb 2014 12:29:51.0802 (UTC) FILETIME=[CD3269A0:01CF21A4]
X-MC-Unique: 114020412295301201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:34:40PM +0000, Andrew Murray wrote:
> On 3 February 2014 18:43, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> > index 4cc813e..ce5bad2 100644
> > --- a/arch/arm64/include/asm/io.h
> > +++ b/arch/arm64/include/asm/io.h
> > @@ -120,9 +120,13 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
> >  /*
> >   *  I/O port access primitives.
> >   */
> > +#define arch_has_dev_port()    (0)
> >  #define IO_SPACE_LIMIT         0xffff
> >  #define PCI_IOBASE             ((void __iomem *)(MODULES_VADDR - SZ_2M))
> >
> > +#define ioport_map(port, nr)   (PCI_IOBASE + ((port) & IO_SPACE_LIMIT))
> > +#define ioport_unmap(addr)
> 
> I'm not sure that this will work. The in[bwl], out[bwl] macros in
> arch/arm64/include/asm/io.h already add the PCI_IOBASE offset.
> 
> Instead of these two #defines, why not just enforce that
> GENERIC_PCI_IOMAP is enabled? Or at least wrap these defines with 'if
> (!config_enabled(CONFIG_GENERIC_PCI_IOMAP))' or similar.

GENERIC_PCI_IOMAP *is* enabled for AArch64. We have select GENERIC_IOMAP in
arch/arm64/Kconfig which in turn selects GENERIC_PCI_IOMAP in lib/Kconfig.

Best regards,
Liviu

> 
> > +
> >  static inline u8 inb(unsigned long addr)
> >  {
> >         return readb(addr + PCI_IOBASE);
> 
> 
> Andrew Murray
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

