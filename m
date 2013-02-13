Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3BMGoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 01:44:39 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47127 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3BMGoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 01:44:37 -0500
Date: Wed, 13 Feb 2013 07:44:36 +0100
From: Andreas Mohr <andi@lisas.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Andreas Mohr <andi@lisas.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: [REGRESSION] [nailed] USB boot failure: USB: EHCI: make ehci-pci a
 separate driver
Message-ID: <20130213064436.GA22583@rhlx01.hs-esslingen.de>
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

Hi guys (*wink*),

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

[I didn't]

Never managed to actually get to run localmodconfig, since I never
got to a bad build again (for properly confirming a reduced-set bad
vs. full-build bad) before finally hitting a subsequent bad one
with very limited incremental build efforts anyway (module headers only), doh...


And the winner is... ("oh no!")


# git bisect good
adfa79d1c06a32650332930ca4c488ca570b3407 is the first bad commit
commit adfa79d1c06a32650332930ca4c488ca570b3407
Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Thu Nov 1 11:13:04 2012 -0400

    USB: EHCI: make ehci-pci a separate driver
    
    This patch (as1625) splits the PCI portion of ehci-hcd out into its
    own separate driver module, called ehci-pci.  Consistently with the
    current practice, the decision whether to build this module is not
    user-configurable.  If EHCI and PCI are enabled then the module will
    be built, always.
    
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    CC: Felipe Balbi <balbi@ti.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 1b7bf7a030df56852a48bf243862f70d5522e098
ad780e9c56d6647de5db9a5e87256ae2a79d4041 M	drivers




# git bisect log
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
# good: [e1deb56cb775ab953bc5245feaf1f43269409139] usb: ehci-s5p: use
# clk_prepare_enable and clk_disable_unprepare
git bisect good e1deb56cb775ab953bc5245feaf1f43269409139
# good: [86effe5980e25f4fac10a0f22938c2fcd4a32690] USB: fix build with
# XEN and EARLY_PRINTK_DBGP enabled but USB_SUPPORT disabled
git bisect good 86effe5980e25f4fac10a0f22938c2fcd4a32690
# good: [571e41214e988bc38c99d804e6d8e1ea1d016342] USB: remove iteration
# limit in hub_tt_work()
git bisect good 571e41214e988bc38c99d804e6d8e1ea1d016342
# good: [7c83b4483606f5fe14127249336ac53ef177a63a] USB: option: idVendor
# and idProduct are __le16
git bisect good 7c83b4483606f5fe14127249336ac53ef177a63a
# bad: [99f91934a907df31ba878dfdd090002049dc476a] USB: EHCI: make
# ehci-platform a separate driver
git bisect bad 99f91934a907df31ba878dfdd090002049dc476a
# bad: [adfa79d1c06a32650332930ca4c488ca570b3407] USB: EHCI: make
# ehci-pci a separate driver
git bisect bad adfa79d1c06a32650332930ca4c488ca570b3407
# good: [3e0232039967d7a1a06c013d097458b4d5892af1] USB: EHCI: prepare to
# make ehci-hcd a library module
git bisect good 3e0232039967d7a1a06c013d097458b4d5892af1



History: Acer Aspire One netbook, boot from USB SSD failed to populate
/dev/disk/by-uuid/ properly, due to enumerating *parts* of the USB
device tree only, as seen via /sys/bus/usb
(see original mail for further details).

Thus it seems this bug was introduced early in the v3.7 -> v3.8-rc1 cycle.
And I failed to have things tested until -rc4, with further delays until
-rc7 since I suspected initramfs/udev package versioning bugs on the newly
re-installed^Wcovered MINT install.


BIOS Information
        Vendor: Acer
        Version: v0.3310
        Release Date: 10/06/2008

System Information
        Manufacturer: Acer
        Product Name: AOA110
        Version: 1


At this point in time I'd like to dedicate some hero memorial moments
to my trusty extrememory 16GB PERFORMANCE SDHC card.
Tough job, completely convincing performance (i.e., "it did survive" -
as that is all that counts... :%).
(I didn't want to sacrifice my main SSD, obviously)


So, what to do? I'm now going to do some experimentation with git revert
on some revision, and I'm trying to establish the USB port dependency
(BIOS-owned handoff root hub invisible!?, as discussed in initial mail).

Andreas Mohr
