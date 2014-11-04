Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaKDRMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:12:15 -0500
Received: from gate.crashing.org ([63.228.1.57]:43449 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaKDRML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:12:11 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3 1/3] QE: move qe code from arch/powerpc to drivers/soc
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <58731211e1a24702a8b5e18834e88663@BLUPR03MB341.namprd03.prod.outlook.com>
Date: Tue, 4 Nov 2014 11:11:58 -0600
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>, Xiaobo Xie <X.Xie@freescale.com>
Content-Transfer-Encoding: 7bit
Message-Id: <51ADDE93-5400-4664-B37F-05710F6AE8A5@kernel.crashing.org>
References: <1414654264-2596-1-git-send-email-B45475@freescale.com> <845EBC7E-52A3-48D6-826D-886FC18B0B88@kernel.crashing.org> <58731211e1a24702a8b5e18834e88663@BLUPR03MB341.namprd03.prod.outlook.com>
To: qiang.zhao@freescale.com
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 31, 2014, at 2:24 AM, qiang.zhao@freescale.com wrote:

> On Oct 30, 2014, at 9:37 AM, Kumar Gala wrote:
> 
> 
>> -----Original Message-----
>> From: Kumar Gala [mailto:galak@kernel.crashing.org]
>> Sent: Thursday, October 30, 2014 9:37 PM
>> To: Zhao Qiang-B45475
>> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood
>> Scott-B07421; Xie Xiaobo-R63061
>> Subject: Re: [PATCH v3 1/3] QE: move qe code from arch/powerpc to
>> drivers/soc
>> 
>> 
>> On Oct 30, 2014, at 2:31 AM, Zhao Qiang <B45475@freescale.com> wrote:
>> 
>>> LS1 is arm cpu and it has qe ip block.
>>> move qe code from platform directory to public directory.
>>> 
>>> QE is an IP block integrates several comunications peripheral
>>> controllers. It can implement a variety of applications, such as uart,
>>> usb and tdm and so on.
>>> 
>>> Signed-off-by: Zhao Qiang <B45475@freescale.com>
>>> ---
>>> Changes for v2:
>>> 	- move code to driver/soc
>>> Changes for v3:
>>> 	- change drivers/soc/qe to drivers/soc/fsl-qe
>>> 
>>> arch/powerpc/Kconfig                               |  2 -
>>> arch/powerpc/platforms/83xx/km83xx.c               |  4 +-
>>> arch/powerpc/platforms/83xx/misc.c                 |  2 +-
>>> arch/powerpc/platforms/83xx/mpc832x_mds.c          |  4 +-
>>> arch/powerpc/platforms/83xx/mpc832x_rdb.c          |  4 +-
>>> arch/powerpc/platforms/83xx/mpc836x_mds.c          |  4 +-
>>> arch/powerpc/platforms/83xx/mpc836x_rdk.c          |  4 +-
>>> arch/powerpc/platforms/85xx/common.c               |  2 +-
>>> arch/powerpc/platforms/85xx/corenet_generic.c      |  2 +-
>>> arch/powerpc/platforms/85xx/mpc85xx_mds.c          |  4 +-
>>> arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |  4 +-
>>> arch/powerpc/platforms/85xx/twr_p102x.c            |  4 +-
>>> arch/powerpc/platforms/Kconfig                     | 19 ---------
>>> arch/powerpc/sysdev/Makefile                       |  1 -
>>> arch/powerpc/sysdev/qe_lib/Kconfig                 | 27 -------------
>>> drivers/net/ethernet/freescale/fsl_pq_mdio.c       |  2 +-
>>> drivers/net/ethernet/freescale/ucc_geth.c          |  8 ++--
>>> drivers/net/ethernet/freescale/ucc_geth.h          |  8 ++--
>>> drivers/soc/Kconfig                                |  2 +
>>> drivers/soc/Makefile                               |  1 +
>>> drivers/soc/fsl-qe/Kconfig                         | 45
>> ++++++++++++++++++++++
>>> .../sysdev/qe_lib => drivers/soc/fsl-qe}/Makefile  |  0
>>> .../sysdev/qe_lib => drivers/soc/fsl-qe}/gpio.c    |  2 +-
>>> .../sysdev/qe_lib => drivers/soc/fsl-qe}/qe.c      |  4 +-
>>> .../sysdev/qe_lib => drivers/soc/fsl-qe}/qe_ic.c   |  2 +-
>>> .../sysdev/qe_lib => drivers/soc/fsl-qe}/qe_ic.h   |  2 +-
>>> .../sysdev/qe_lib => drivers/soc/fsl-qe}/qe_io.c   |  2 +-
>>> .../sysdev/qe_lib => drivers/soc/fsl-qe}/ucc.c     |  6 +--
>>> .../qe_lib => drivers/soc/fsl-qe}/ucc_fast.c       |  8 ++--
>>> .../qe_lib => drivers/soc/fsl-qe}/ucc_slow.c       |  8 ++--
>>> .../sysdev/qe_lib => drivers/soc/fsl-qe}/usb.c     |  4 +-
>>> drivers/spi/spi-fsl-cpm.c                          |  2 +-
>>> drivers/tty/serial/ucc_uart.c                      |  2 +-
>>> drivers/usb/gadget/fsl_qe_udc.c                    |  2 +-
>>> drivers/usb/host/fhci-hcd.c                        |  2 +-
>>> drivers/usb/host/fhci-hub.c                        |  2 +-
>>> drivers/usb/host/fhci-sched.c                      |  2 +-
>>> drivers/usb/host/fhci.h                            |  4 +-
>>> .../include/asm => include/linux/fsl}/immap_qe.h   |  0
>>> .../powerpc/include/asm => include/linux/fsl}/qe.h |  2 +-
>>> .../include/asm => include/linux/fsl}/qe_ic.h      |  0
>>> .../include/asm => include/linux/fsl}/ucc.h        |  4 +-
>>> .../include/asm => include/linux/fsl}/ucc_fast.h   |  6 +--
>>> .../include/asm => include/linux/fsl}/ucc_slow.h   |  6 +--
>>> 44 files changed, 112 insertions(+), 113 deletions(-) delete mode
>>> 100644 arch/powerpc/sysdev/qe_lib/Kconfig
>>> create mode 100644 drivers/soc/fsl-qe/Kconfig rename
>>> {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/Makefile (100%)
>>> rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/gpio.c (99%)
>>> rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/qe.c (99%)
>>> rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/qe_ic.c
>>> (99%) rename {arch/powerpc/sysdev/qe_lib =>
>>> drivers/soc/fsl-qe}/qe_ic.h (98%) rename {arch/powerpc/sysdev/qe_lib
>>> => drivers/soc/fsl-qe}/qe_io.c (99%) rename
>>> {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/ucc.c (98%) rename
>>> {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/ucc_fast.c (98%)
>>> rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/ucc_slow.c
>>> (98%) rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/usb.c
>>> (96%) rename {arch/powerpc/include/asm =>
>>> include/linux/fsl}/immap_qe.h (100%) rename {arch/powerpc/include/asm
>>> => include/linux/fsl}/qe.h (99%) rename {arch/powerpc/include/asm =>
>>> include/linux/fsl}/qe_ic.h (100%) rename {arch/powerpc/include/asm =>
>>> include/linux/fsl}/ucc.h (96%) rename {arch/powerpc/include/asm =>
>>> include/linux/fsl}/ucc_fast.h (98%) rename {arch/powerpc/include/asm
>>> => include/linux/fsl}/ucc_slow.h (99%)
>> 
>> 
>> So you should be moving things to drivers/soc/fsl/qe/ not
>> drivers/soc/fsl-qe/
>> 
>> The headers should be in include/soc/fsl, not include/linux/fsl
> 
> I don't understand why I need to put headers in include/soc/fsl,
> Can you explain more?

Because that is the location of headers associated with drivers/soc

- k
