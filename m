Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaDUDDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 23:03:17 -0400
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:47345
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751284AbaDUDDM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 23:03:12 -0400
Message-ID: <1398049388.7753.6.camel@leyfoon-vm>
Subject: Re: [PATCH 01/28] nios2: Build infrastructure
From: Ley Foon Tan <lftan@altera.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Date: Mon, 21 Apr 2014 11:03:08 +0800
In-Reply-To: <20140418143553.GB8589@ravnborg.org>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	 <1397824031-4892-2-git-send-email-lftan@altera.com>
	 <20140418143553.GB8589@ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(377424004)(24454002)(51704005)(189002)(199002)(80022001)(92726001)(92566001)(575784001)(62966002)(86362001)(80976001)(93916002)(33646001)(4396001)(50226001)(81542001)(33716001)(87286001)(89996001)(85852003)(83072002)(81342001)(87936001)(99396002)(88136002)(50986999)(97736001)(2009001)(23676002)(77156001)(31966008)(74502001)(74662001)(16796002)(19580395003)(19580405001)(44976005)(42186004)(83322001)(76176999)(79102001)(6806004)(76482001)(77982001)(20776003)(47776003)(46102001)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2FFO11HUB023;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:C007E3E6.A03AC5D9.4AC7650E.98E8CE45.2035D;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0188D66E61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jum, 2014-04-18 at 16:35 +0200, Sam Ravnborg wrote:
> It is good practice to add build infrastructure last - so build is not broken.
> But for a new architecture it matters only little.
> 
> Some comments in the following.
> 
> 	Sam
Noted. But, I will keep the patch # for this time for consistency.
Thanks. 
> > 
> > Signed-off-by: Ley Foon Tan <lftan@altera.com>
> > ---
> > 
> > diff --git a/arch/nios2/Kconfig b/arch/nios2/Kconfig
> > new file mode 100644
> > index 0000000..2bd0d0d7160f31a5c5890cf8a059b9f53378be6e
> > --- /dev/null
> > +++ b/arch/nios2/Kconfig
> > @@ -0,0 +1,213 @@
> > +config NIOS2
> > +	def_bool y
> > +	select OF
> > +	select OF_EARLY_FLATTREE
> > +	select USB_ARCH_HAS_HCD if USB_SUPPORT
> > +	select ARCH_WANT_OPTIONAL_GPIOLIB
> > +	select GENERIC_IRQ_PROBE
> > +	select GENERIC_IRQ_SHOW
> > +	select GENERIC_CPU_DEVICES
> > +	select GENERIC_ATOMIC64
> > +	select MODULES_USE_ELF_RELA
> > +	select IRQ_DOMAIN
> > +	select SOC_BUS
> > +	select CLKSRC_OF
> If you keep this list sorted then merge issues are less likely.
Noted, will sort this list.

> > +config KERNEL_MMU_REGION_BASE_BOOL
> > +	bool "Set custom kernel MMU region base address"
> > +	depends on ADVANCED_OPTIONS
> > +	help
> > +	  This option allows you to set the virtual address of the kernel MMU region.
> > +
> > +	  Say N here unless you know what you are doing.
> 
> All Nios2 specific options should be prefixed with NIOS2_
> This is what is done for all new arch specific symbols.
Noted, will add NIOS2 prefix to these CONFIGs.
> 
> > diff --git a/arch/nios2/boot/Makefile b/arch/nios2/boot/Makefile

> > +	$(call if_changed,gzip)
> > +
> > +$(obj)/vmImage: $(obj)/vmlinux.gz
> > +	$(call if_changed,uimage)
> > +	@$(kecho) 'Kernel: $@ is ready'
> 
> Add:
> targets += vmlinux.bin vmlinux.gz vmImage
> to make $(call if_changed ... actually work.
Sure, will change to this way.

> 
> 
> > +obj-y += cpuinfo.o insnemu.o irq.o nios2_ksyms.o process.o prom.o ptrace.o \
> > +	 setup.o signal.o sys_nios2.o syscall_table.o time.o traps.o
> 
> In new stuff try to avoid using ... \
> to contatenate lines.
> Use:
> obj-y += xxx
> 
> This is much more readable.
> 
Will fix this.
