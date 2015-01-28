Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbbA2BK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:10:57 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:59034 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752761AbbA2BKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:10:52 -0500
Message-ID: <1422480756.3621.52.camel@x220>
Subject: Re: [PATCH 1/1] kconfig: warn if an unknown symbol is selected
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2015 22:32:36 +0100
In-Reply-To: <54C8FFBA.5040000@suse.cz>
References: <1412100583.21730.31.camel@x220>
		 <1415014691.20372.49.camel@x220> <1422438897.5666.23.camel@x220>
	 <54C8FFBA.5040000@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2015 21:32:36.0198 (UTC) FILETIME=[EEF96860:01D03B41]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-28 at 16:26 +0100, Michal Marek wrote:
> On 2015-01-28 10:54, Paul Bolle wrote:
> > Now that we've been told Yann has disappeared, would you consider taking
> > this patch into one of your trees? It would be nice to have people
> > actually use it for a while.
> > 
> > Or should we first clean up (most of) the warnings it generates? There
> 
> It seems your fixes have been accepted in the meantime, but there is one
> new:
> *** Default configuration is based on 'x86_64_defconfig'
> drivers/misc/cxl/Kconfig:8:warning: 'CXL_BASE' selects unknown symbol
> 'PPC_COPRO_BASE'
> 
> PPC_COPRO_BASE is not known on x86, but at the same time, there is no
> way for CXL_BASE to be selected on x86:
> 
> config CXL_BASE
> 	bool
> 	default n
> 	select PPC_COPRO_BASE
> 
> config CXL
> 	tristate "Support for IBM Coherent Accelerators (CXL)"
> 	depends on PPC_POWERNV && PCI_MSI
> 	select CXL_BASE
> 	default m
> 
> Shouldn't we only warn about a select when it is triggered? An
> allyesconfig would still report all bogus selects for given architecture.

Good catch! I think checking only for selects done by Kconfig symbols
that are not "n" might do the trick. Expect a v2 one of these days.

The current load of issues (for allyesconfig on all arches except um) is
pasted at the bottom of this message (with some comments added). Looking
at that load I think it might be preferable to first most of fix those
issues before adding this to kconfig.


Paul Bolle

alpha:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'

REMOTEPROC should be ARM or OMAP specific?

lib/Kconfig.debug:1024:warning: 'DEBUG_ATOMIC_SLEEP' selects unknown symbol 'PREEMPT_COUNT'

Perhaps fixed by selecting PREEMPT_COUNT only for architectures that
support it.

arc:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
arm:
arch/arm/mach-mvebu/Kconfig:40:warning: 'MACH_ARMADA_375' selects unknown symbol 'ARM_ERRATA_753970'
arch/arm/mach-mvebu/Kconfig:55:warning: 'MACH_ARMADA_38X' selects unknown symbol 'ARM_ERRATA_753970'

I'm trying for quite some time to get this fixed.

arm64:
arch/arm64/Kconfig:183:warning: 'ARCH_TEGRA' selects unknown symbol 'HAVE_SMP'
arch/arm64/Kconfig:193:warning: 'ARCH_TEGRA_132_SOC' selects unknown symbol 'USB_ARCH_HAS_EHCI'

Patches pending, I've been told.

drivers/irqchip/Kconfig:9:warning: 'ARM_GIC' selects unknown symbol 'MULTI_IRQ_HANDLER'
drivers/irqchip/Kconfig:23:warning: 'ARM_GIC_V3' selects unknown symbol 'MULTI_IRQ_HANDLER'

MULTI_IRQ_HANDLER is arm specific.

avr32:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
blackfin:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
c6x:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
cris:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
frv:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
lib/Kconfig.debug:1024:warning: 'DEBUG_ATOMIC_SLEEP' selects unknown symbol 'PREEMPT_COUNT'
hexagon:
arch/hexagon/Kconfig:22:warning: 'HEXAGON' selects unknown symbol 'NO_IOPORT_MAP'

Fixing obscure architectures requires patience!

drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
lib/Kconfig.debug:1024:warning: 'DEBUG_ATOMIC_SLEEP' selects unknown symbol 'PREEMPT_COUNT'
ia64:
drivers/acpi/Kconfig:165:warning: 'ACPI_PROCESSOR' selects unknown symbol 'CPU_IDLE'

Perhaps, again, fixed by only selecting CPU_IDLE on architectures that
support it.

drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
m32r:
m68k:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
metag:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
microblaze:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
mips:
mn10300:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
nios2:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
openrisc:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
parisc:
sound/pci/Kconfig:28:warning: 'SND_ALS300' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:53:warning: 'SND_ALI5451' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:158:warning: 'SND_AZT3328' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:466:warning: 'SND_EMU10K1' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:482:warning: 'SND_EMU10K1X' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:516:warning: 'SND_ES1938' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:528:warning: 'SND_ES1968' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:615:warning: 'SND_ICE1712' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:703:warning: 'SND_MAESTRO3' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:821:warning: 'SND_SONICVIBES' selects unknown symbol 'ZONE_DMA'
sound/pci/Kconfig:833:warning: 'SND_TRIDENT' selects unknown symbol 'ZONE_DMA'

I guess one or more cases of !PARISC might do the trick. But the
underlying problem is quite complicated. See commit 80ab8eae70e5 ("ALSA:
Enable CONFIG_ZONE_DMA for smaller PCI DMA masks"). Rather nice quote
from Andrew Morton about adding these selects (instead of fixing the
underlying problem):
    But then we'll just forget about it :(

(https://bugzilla.kernel.org/show_bug.cgi?id=68221#c19 ).

drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
powerpc:
s390:
score:
arch/score/Kconfig:28:warning: 'MACH_SPCT6600' selects unknown symbol 'SYS_SUPPORTS_32BIT_KERNEL'

Fixing obscure architectures requires patience!

sh:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
sparc:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
tile:
unicore32:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'
x86:
xtensa:
drivers/remoteproc/Kconfig:10:warning: 'REMOTEPROC' selects unknown symbol 'VIRTUALIZATION'

