Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3BLVZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:25:05 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52904 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3BLVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:25:03 -0500
Date: Tue, 12 Feb 2013 22:25:01 +0100
From: Andreas Mohr <andi@lisas.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andreas Mohr <andi@lisas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] -rc7/-rc4+: unable to USB boot - enumeration
 partially broken (was: Linux v3.8-rc7)
Message-ID: <20130212212501.GA22669@rhlx01.hs-esslingen.de>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130210001442.GA5744@rhlx01.hs-esslingen.de>
 <20130210140554.GA5299@rhlx01.hs-esslingen.de>
 <20130212160727.GA15857@rhlx01.hs-esslingen.de>
 <20130212161617.GA3887@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212161617.GA3887@kroah.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 12, 2013 at 08:16:17AM -0800, Greg KH wrote:
> On Tue, Feb 12, 2013 at 05:07:27PM +0100, Andreas Mohr wrote:
> > On Sun, Feb 10, 2013 at 03:05:54PM +0100, Andreas Mohr wrote:
> > > Regression sorta confirmed now. -rc3 with a fully suitable .config does
> > > not boot either. Will start bisection. Will take ages.
> > 
> > Down to 91 commits (all in USB land!), around 7 steps left.
> > Pretty certain of a valid regression now. Things did properly do the
> > good/good/bad/bad/good... dance.
> > 
> > Oh so lovely if you're constrained to >= 5 hour build times,
> 
> You do know about 'make localmodconfig', right?  That should cut your
> build time down a large amount.

No, I didn't know, and quirky kernel docs don't know either (yet another
item I've got to add to my update commits) [and 1.7.10.4
bisect man obviously doesn't mention it either]. Hrmm, README does
explain it. Ought to have managed to read at least the first batch
of rough introductory docs parts in full, mayhaps? :%

Still, something to be referenced in a (currently very terse) more suitable
doc for bisection (i.e. BUG-HUNTING).

Thanks two tons for the life-saver! :)


Current candidates remaining (45 revisions, 6 steps,
git bisect visualize --oneline),
for those who might already want to know it at this moment
(and yes, the last one was bad, so seems I'm on track):


09f6ffd USB: EHCI: fix build error by making ChipIdea host a normal EHCI
driver
5746510 USB: ohci-exynos: initialize registers pointer earlier
d1bb67a USB: EHCI: fix build error in ehci-platform.c under PowerPC
99f9193 USB: EHCI: make ehci-platform a separate driver
adfa79d USB: EHCI: make ehci-pci a separate driver
3e02320 USB: EHCI: prepare to make ehci-hcd a library module
7c83b44 USB: option: idVendor and idProduct are __le16
dbdf680 USB: option: replace vendor probe rule with match flags
17b72fe USB: add USB_DEVICE_INTERFACE_CLASS macro
1b95bee USB: option: never bind to a usb-storage interface
c73cee7 USB: EHCI: remove ehci_port_power() routine
4968f95 USB: EHCI: remove unused Link Power Management code
571e412 USB: remove iteration limit in hub_tt_work()
bcbec05 USB: serial: remove driver version information
806df3a USB: ums_realtek: fix build warning
5fb0432 USB: ftdi_sio: use ftdi_get_modem_status in chars_in_buffer
8da636d USB: ftdi_sio: optimise chars_in_buffer
755b604 USB: ftdi_sio: use generic chars_in_buffer
428d998 USB: serial: export usb_serial_generic_chars_in_buffer
a4afff6 USB: ftdi_sio: refactor modem-control status retrieval
2c2ee54 USB: ftdi_sio: fix tiocmget and tiocmset return values
fef0b82 USB: ftdi_sio: fix tiocmget indentation
81e8442 USB: ftdi_sio: remove unused private port-data
86effe5 USB: fix build with XEN and EARLY_PRINTK_DBGP enabled but
USB_SUPPORT di
d067a31 USB: ftdi_sio: remove unnecessary memset
4f2ab88 USB: cp210x: fix whitespace issues
487c151 USB: iuu_phoenix: replace strict_strtoul() with kstrtoul()
f2ec522 usb: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
b472b8e Merge 3.7-rc3 into usb-next.
d124a60 USB: isp1760-if: Change to use irq_of_parse_and_map
596d789 USB: set hub's default autosuspend delay as 0
e6f30de USB: check port changes before hub runtime suspend for some bug
device
b717727 umc-bus.c: fix usage of device_trylock
6f60291 usb: serial: ftdi_sio: Add missing chars_in_buffer function
bd066ee usb: "ehci-w90x900" Fix a typo and add some whitespace.
bfd1e91 USB: speed up usb_bus_resume()
969ddcf USB: hub_for_each_child should skip unconnected ports
d39dbc8 USB: EHCI: move ehci_update_device() to ehci-lpm.c
acc0850 USB: EHCI: make ehci_read_frame_index platform independent
d6064ac USB: EHCI: move logging macros to ehci.h
6273f18 USB: EHCI: add condition for delay during the resume
e8cebb9 USB: usb-skeleton.c: fix compilation error and restored kref_put
on fail
801f006 USB: ohci-s3c2410: use devm_ functions
30b1e49 USB: use bus_to_hdc instead of container_of
60d80ad USB: ohci-exynos: use devm_clk_get()
c05c946 usb: ohci-exynos: use clk_prepare_enable and
clk_disable_unprepare
e1deb56 usb: ehci-s5p: use clk_prepare_enable and clk_disable_unprepare
ffc7493 usb: phy: tegra remove include of <mach/iomap.h>
54388b2 usb: host: tegra remove include of <mach/iomap.h>
c30186e USB: ezusb: unexport some functions that aren't being used
068b054 USB: OHCI: sm501: fix build failure after
ohci_finish_controller_resume 
5843de3 MIPS: Alchemy: update development boards defconfigs with USB
platform dr
da31fe4 WUSB: remove an unnused variable
be7ac70 USB: OHCI: make ohci-platform use devm_request_and_ioremap
helper
61ff274 USB: EHCI: make ehci-platform use devm_request_and_ioremap
helper
ac0e3c0 USB: OHCI: fix typo in ohci-platform driver on the word
"resource"
5c9b2b2 USB: EHCI: fix typo in ehci-platform driver on the word
"resource"
976baf6 USB: OHCI: make ohci-platform use dev_err() instead of pr_err()
2350cb0 USB: EHCI: make ehci-platform use dev_err() instead of pr_err()
216d0fd USB: move common alchemy USB routines to
arch/mips/alchemy/common.c
bb5da43 USB: OHCI: remove Alchemy OHCI platform driver.
e223a4c MIPS: Alchemy: use the OHCI platform driver
231a72e USB: OHCI: remove OHCI SH platform driver
7518f07 sh: convert boards to use the OHCI platform driver
c2e91e0 USB: OHCI: remove Netlogic XLS OHCI platform driver
ee2ef6b MIPS: Netlogic: convert to use OHCI platform driver
c23920b USB: OHCI: remove CNS3xxx OHCI platform driver
6da00dd ARM: cns3xxx: use OHCI platform driver
60da65f USB: OHCI: remove PNX8550 OHCI driver
f2028bd MIPS: PNX8550: use OHCI platform driver
cfa49b4 USB: ohci: merge ohci_finish_controller_resume with ohci_resume
d4ae47d USB: ohci: remove check for RH already suspended in ohci_suspend
cd1965d USB: ohci: move ohci_pci_{suspend,resume} to ohci-hcd.c
2b16e39 USB: ohci: allow platform driver to specify the number of ports
f3a958d USB: EHCI: remove CNS3xxx EHCI platform driver
b898f5f ARM: cns3xxx: use ehci platform driver
1de7d89 USB: EHCI: remove Alchemy EHCI driver
2be350f MIPS: Alchemy: use the ehci platform driver
4534874 USB: EHCI: add no_io_watchdog platform_data parameter to
ehci-platform
6d39944 USB: EHCI: remove Netlogic XLS EHCI driver
1bee8d4 MIPS: Netlogic: use ehci-platform driver
ead92fa USB: EHCI: remove Loongson 1B EHCI driver.
afe046b MIPS: Loongson 1B: use ehci-platform instead of ehci-ls1x.
7bccfcd USB: OHCI: remove ohci-pcc-soc driver.
6efd0f7 USB: EHCI: remove IXP4xx EHCI driver
6a41b4d OHCI: implement new semantics for URB_ISO_ASAP
c44b225 UHCI: implement new semantics for URB_ISO_ASAP
4005ad4 EHCI: implement new semantics for URB_ISO_ASAP
a03bede USB: update documentation for URB_ISO_ASAP
7267547 EHCI: replace mult/div with bit-mask operation
98cae42 EHCI: use the isochronous scheduling threshold
c3ee9b7 EHCI: improved logic for isochronous scheduling



$ git bisect log
git bisect start
# bad: [9931faca02c604c22335f5a935a501bb2ace6e20] Linux 3.8-rc3
git bisect bad 9931faca02c604c22335f5a935a501bb2ace6e20
# good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
git bisect good 29594404d7fe73cd80eaa4ee8c43dcc53970c60e
# good: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
git bisect good 29594404d7fe73cd80eaa4ee8c43dcc53970c60e
# bad: [db5b0ae00712b5176d7405e7a1dd2bfd6e8f5070] Merge tag 'dt' of
# git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect bad db5b0ae00712b5176d7405e7a1dd2bfd6e8f5070
# bad: [fef3ff2eb777e76cfa5ae67591982d902c17139c] Merge branch 'for-3.8'
# of git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu
git bisect bad fef3ff2eb777e76cfa5ae67591982d902c17139c
# good: [7bcb57cde66c19df378f3468ea342166a8a4504d] Merge tag
# 'iio-for-3.8f' of
# git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into
# staging-next
git bisect good 7bcb57cde66c19df378f3468ea342166a8a4504d
# good: [c6bd5bcc4983f1a2d2f87a3769bf309482ee8c04] Merge tag
# 'tty-3.8-rc1' of
# git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty
git bisect good c6bd5bcc4983f1a2d2f87a3769bf309482ee8c04
# bad: [aefb058b0c27dafb15072406fbfd92d2ac2c8790] Merge branch
# 'irq-core-for-linus' of
# git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad aefb058b0c27dafb15072406fbfd92d2ac2c8790
# bad: [70847780dca19f3707d9fa433f68edf8cbaf91f2] usb: host: tegra:
# remove pointless NULL check in tegra_ehci_remove()
git bisect bad 70847780dca19f3707d9fa433f68edf8cbaf91f2
# bad: [09f6ffde2ecef4cc4e2a5edaa303210cabd96f57] USB: EHCI: fix build
# error by making ChipIdea host a normal EHCI driver
git bisect bad 09f6ffde2ecef4cc4e2a5edaa303210cabd96f57


Andreas Mohr
