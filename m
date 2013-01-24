Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3AXACL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:02:11 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45549 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab3AXACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:02:07 -0500
Date: Wed, 23 Jan 2013 16:02:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] more USB fixes for 3.8-rc4
Message-ID: <20130124000202.GA12566@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.8-rc4

for you to fetch changes up to dba63b2f733ebfd89bbb15e8fe8ca10fd3871a7f:

  USB: EHCI: fix build error in ehci-mxc (2013-01-23 11:27:08 -0800)

----------------------------------------------------------------
more USB fixes for 3.8-rc4

Here are some more USB fixes for the 3.8-rc4 tree.

Some gadget driver fixes, and finally resolved the ehci-mxc driver build issues
(it's just some code moving around and being deleted).

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

----------------------------------------------------------------
Alan Stern (4):
      USB: UHCI: fix IRQ race during initialization
      USB: EHCI: fix incorrect configuration test
      USB: EHCI: add a name for the platform-private field
      USB: EHCI: fix build error in ehci-mxc

Benoit Goby (1):
      usb: gadget: FunctionFS: Fix missing braces in parse_opts

Greg Kroah-Hartman (1):
      Merge tag 'fixes-for-v3.8-rc5' of git://git.kernel.org/.../balbi/usb into usb-linus

Peter Chen (3):
      usb: gadget: fsl-mxc-udc: replace cpu_is_xxx() with platform_device_id
      usb: gadget: fsl_mxc_udc: replace MX35_IO_ADDRESS to ioremap
      ARM: i.MX clock: Change the connection-id for fsl-usb2-udc

Pratyush Anand (1):
      usb: dwc3: gadget: fix ep->maxburst for ep0

Roger Quadros (1):
      USB: EHCI: Move definition of EHCI_STATS to ehci.h

Sergei Shtylyov (1):
      usb: musb: cppi_dma: drop '__init' annotation

 arch/arm/mach-imx/clk-imx25.c                     |   6 ++--
 arch/arm/mach-imx/clk-imx27.c                     |   6 ++--
 arch/arm/mach-imx/clk-imx31.c                     |   6 ++--
 arch/arm/mach-imx/clk-imx35.c                     |   6 ++--
 arch/arm/mach-imx/clk-imx51-imx53.c               |   6 ++--
 arch/arm/mach-imx/devices/devices-common.h        |   1 +
 arch/arm/mach-imx/devices/platform-fsl-usb2-udc.c |  15 ++++-----
 drivers/usb/dwc3/gadget.c                         |   1 +
 drivers/usb/gadget/f_fs.c                         |   6 ++--
 drivers/usb/gadget/fsl_mxc_udc.c                  |  40 +++++++++++++++---------
 drivers/usb/gadget/fsl_udc_core.c                 |  42 ++++++++++++++-----------
 drivers/usb/gadget/fsl_usb2_udc.h                 |   5 +--
 drivers/usb/host/Kconfig                          |   2 +-
 drivers/usb/host/Makefile                         |   1 +
 drivers/usb/host/ehci-hcd.c                       |  12 ++------
 drivers/usb/host/ehci-mxc.c                       | 120 ++++++++++++++++++++++++++++++------------------------------------------
 drivers/usb/host/ehci.h                           |   7 +++++
 drivers/usb/host/uhci-hcd.c                       |  15 +++++----
 drivers/usb/musb/cppi_dma.c                       |   4 +--
 drivers/usb/serial/io_ti.c                        |   3 ++
 drivers/usb/serial/option.c                       |   9 +++++-
 21 files changed, 165 insertions(+), 148 deletions(-)
