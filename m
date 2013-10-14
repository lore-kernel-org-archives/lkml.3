Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab3JNTk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:40:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:41488 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab3JNTk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:40:56 -0400
Subject: Re: [PATCH] powerpc/qe_lib: Share the qe_lib for the others architecture
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <8559CF98-88E4-4271-A873-1409359EFE5C@kernel.crashing.org>
Date: Mon, 14 Oct 2013 14:40:44 -0500
Cc: Scott Wood <scottwood@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3F4D4A39-3063-45F5-8B0E-3CD5F36B4035@kernel.crashing.org>
References: <1381750622-1150-1-git-send-email-X.Xie@freescale.com> <8559CF98-88E4-4271-A873-1409359EFE5C@kernel.crashing.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 14, 2013, at 2:26 PM, Kumar Gala wrote:

> 
> On Oct 14, 2013, at 6:37 AM, Xie Xiaobo wrote:
> 
>> The QUICC Engine (QE) is a communications coprocessors on Freescale
>> embedded processors. The QE had been applied in PowerPC architecture
>> previously, and it will be applied in ARM architecture too.
>> So move the qe_lib from arch/powerpc to driver/ firstly.
>> 
>> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
>> ---
>> arch/powerpc/Kconfig                         |   2 -
>> arch/powerpc/include/asm/immap_qe.h          | 491 -----------------
>> arch/powerpc/include/asm/qe.h                | 740 -------------------------
>> arch/powerpc/include/asm/qe_ic.h             | 144 -----
>> arch/powerpc/include/asm/ucc.h               |  64 ---
>> arch/powerpc/include/asm/ucc_fast.h          | 244 --------
>> arch/powerpc/include/asm/ucc_slow.h          | 290 ----------
>> arch/powerpc/platforms/85xx/mpc85xx_mds.c    |   4 +-
>> arch/powerpc/platforms/85xx/mpc85xx_rdb.c    |   4 +-
>> arch/powerpc/platforms/Kconfig               |  19 -
>> arch/powerpc/sysdev/Makefile                 |   1 -
>> arch/powerpc/sysdev/qe_lib/Kconfig           |  27 -
>> arch/powerpc/sysdev/qe_lib/Makefile          |  10 -
>> arch/powerpc/sysdev/qe_lib/gpio.c            | 317 -----------
>> arch/powerpc/sysdev/qe_lib/qe.c              | 708 ------------------------
>> arch/powerpc/sysdev/qe_lib/qe_ic.c           | 501 -----------------
>> arch/powerpc/sysdev/qe_lib/qe_ic.h           | 103 ----
>> arch/powerpc/sysdev/qe_lib/qe_io.c           | 218 --------
>> arch/powerpc/sysdev/qe_lib/ucc.c             | 213 -------
>> arch/powerpc/sysdev/qe_lib/ucc_fast.c        | 364 ------------
>> arch/powerpc/sysdev/qe_lib/ucc_slow.c        | 380 -------------
>> arch/powerpc/sysdev/qe_lib/usb.c             |  56 --
>> drivers/Kconfig                              |   2 +
>> drivers/Makefile                             |   3 +
>> drivers/net/ethernet/freescale/fsl_pq_mdio.c |   2 +-
>> drivers/net/ethernet/freescale/ucc_geth.c    |   8 +-
>> drivers/net/ethernet/freescale/ucc_geth.h    |   8 +-
>> drivers/qe/Kconfig                           |  51 ++
>> drivers/qe/Makefile                          |  10 +
>> drivers/qe/gpio.c                            | 317 +++++++++++
>> drivers/qe/qe.c                              | 708 ++++++++++++++++++++++++
>> drivers/qe/qe_common.c                       | 187 +++++++
>> drivers/qe/qe_ic.c                           | 501 +++++++++++++++++
>> drivers/qe/qe_ic.h                           | 103 ++++
>> drivers/qe/qe_io.c                           | 218 ++++++++
>> drivers/qe/ucc.c                             | 213 +++++++
>> drivers/qe/ucc_fast.c                        | 364 ++++++++++++
>> drivers/qe/ucc_slow.c                        | 380 +++++++++++++
>> drivers/qe/usb.c                             |  56 ++
>> drivers/spi/spi-fsl-cpm.c                    |   2 +-
>> drivers/tty/serial/ucc_uart.c                |   2 +-
>> include/qe/immap_qe.h                        | 491 +++++++++++++++++
>> include/qe/qe.h                              | 794 +++++++++++++++++++++++++++
>> include/qe/qe_ic.h                           | 144 +++++
>> include/qe/ucc.h                             |  64 +++
>> include/qe/ucc_fast.h                        | 244 ++++++++
>> include/qe/ucc_slow.h                        | 290 ++++++++++
>> 47 files changed, 5155 insertions(+), 4907 deletions(-)
>> delete mode 100644 arch/powerpc/include/asm/immap_qe.h
>> delete mode 100644 arch/powerpc/include/asm/qe.h
>> delete mode 100644 arch/powerpc/include/asm/qe_ic.h
>> delete mode 100644 arch/powerpc/include/asm/ucc.h
>> delete mode 100644 arch/powerpc/include/asm/ucc_fast.h
>> delete mode 100644 arch/powerpc/include/asm/ucc_slow.h
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/Kconfig
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/Makefile
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/gpio.c
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/qe.c
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/qe_ic.c
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/qe_ic.h
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/qe_io.c
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/ucc.c
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/ucc_fast.c
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/ucc_slow.c
>> delete mode 100644 arch/powerpc/sysdev/qe_lib/usb.c
>> create mode 100644 drivers/qe/Kconfig
>> create mode 100644 drivers/qe/Makefile
>> create mode 100644 drivers/qe/gpio.c
>> create mode 100644 drivers/qe/qe.c
>> create mode 100644 drivers/qe/qe_common.c
>> create mode 100644 drivers/qe/qe_ic.c
>> create mode 100644 drivers/qe/qe_ic.h
>> create mode 100644 drivers/qe/qe_io.c
>> create mode 100644 drivers/qe/ucc.c
>> create mode 100644 drivers/qe/ucc_fast.c
>> create mode 100644 drivers/qe/ucc_slow.c
>> create mode 100644 drivers/qe/usb.c
>> create mode 100644 include/qe/immap_qe.h
>> create mode 100644 include/qe/qe.h
>> create mode 100644 include/qe/qe_ic.h
>> create mode 100644 include/qe/ucc.h
>> create mode 100644 include/qe/ucc_fast.h
>> create mode 100644 include/qe/ucc_slow.h
> 
> Before this is moved you should address the PPC specific issues in the code.  Use of PPC_LIB_RHEAP, the IO macros which are not cross platform, etc.
> 
> Also, copy linux-kernel list as I'm not sure drivers/qe would be the recommendation location for this to end up at.

Greg,

Wondering your thoughts on drivers/qe vs something like drivers/soc/fsl/qe.  The QuiccEngine (qe) is a communication core on some of the Freescale networking SoCs that provides the ability to do various networking/communication functionality.  "Channels" on the QE can be used for various different things from ethernet, ATM, UART, or other functions.

I've already commented that some of what is in qe_lib today needs to move to things like drivers/irqchip, drivers/pinctrl, drivers/gpio, etc.  However, there will still be some qe specific code that doesn't have a natural home in drivers/ today.

- k