Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761330AbaJaH0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:26:12 -0400
Received: from [65.55.169.110] ([65.55.169.110]:63024 "EHLO
	na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761043AbaJaH0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:26:08 -0400
From: "qiang.zhao@freescale.com" <qiang.zhao@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Scott Wood <scottwood@freescale.com>, Xiaobo Xie <X.Xie@freescale.com>
Subject: RE: [PATCH v3 1/3] QE: move qe code from arch/powerpc to drivers/soc
Thread-Topic: [PATCH v3 1/3] QE: move qe code from arch/powerpc to drivers/soc
Thread-Index: AQHP9BOXGb72x87NtkKPpYeSVCDOwZxIpPkAgAEo3SA=
Date: Fri, 31 Oct 2014 07:24:49 +0000
Message-ID: <58731211e1a24702a8b5e18834e88663@BLUPR03MB341.namprd03.prod.outlook.com>
References: <1414654264-2596-1-git-send-email-B45475@freescale.com>
 <845EBC7E-52A3-48D6-826D-886FC18B0B88@kernel.crashing.org>
In-Reply-To: <845EBC7E-52A3-48D6-826D-886FC18B0B88@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0736;
x-forefront-prvs: 03818C953D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(377454003)(24454002)(189002)(13464003)(92566001)(106356001)(106116001)(99396003)(86362001)(85852003)(31966008)(105586002)(97736003)(54356999)(50986999)(4396001)(101416001)(107046002)(95666004)(99286002)(87936001)(66066001)(20776003)(64706001)(21056001)(120916001)(2656002)(76482002)(85306004)(40100003)(19580395003)(122556002)(80022003)(76176999)(19580405001)(74316001)(33646002)(110136001)(46102003)(76576001)(108616004)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0736;H:BLUPR03MB341.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 30, 2014, at 9:37 AM, Kumar Gala wrote:


> -----Original Message-----
> From: Kumar Gala [mailto:galak@kernel.crashing.org]
> Sent: Thursday, October 30, 2014 9:37 PM
> To: Zhao Qiang-B45475
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Wood
> Scott-B07421; Xie Xiaobo-R63061
> Subject: Re: [PATCH v3 1/3] QE: move qe code from arch/powerpc to
> drivers/soc
> 
> 
> On Oct 30, 2014, at 2:31 AM, Zhao Qiang <B45475@freescale.com> wrote:
> 
> > LS1 is arm cpu and it has qe ip block.
> > move qe code from platform directory to public directory.
> >
> > QE is an IP block integrates several comunications peripheral
> > controllers. It can implement a variety of applications, such as uart,
> > usb and tdm and so on.
> >
> > Signed-off-by: Zhao Qiang <B45475@freescale.com>
> > ---
> > Changes for v2:
> > 	- move code to driver/soc
> > Changes for v3:
> > 	- change drivers/soc/qe to drivers/soc/fsl-qe
> >
> > arch/powerpc/Kconfig                               |  2 -
> > arch/powerpc/platforms/83xx/km83xx.c               |  4 +-
> > arch/powerpc/platforms/83xx/misc.c                 |  2 +-
> > arch/powerpc/platforms/83xx/mpc832x_mds.c          |  4 +-
> > arch/powerpc/platforms/83xx/mpc832x_rdb.c          |  4 +-
> > arch/powerpc/platforms/83xx/mpc836x_mds.c          |  4 +-
> > arch/powerpc/platforms/83xx/mpc836x_rdk.c          |  4 +-
> > arch/powerpc/platforms/85xx/common.c               |  2 +-
> > arch/powerpc/platforms/85xx/corenet_generic.c      |  2 +-
> > arch/powerpc/platforms/85xx/mpc85xx_mds.c          |  4 +-
> > arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |  4 +-
> > arch/powerpc/platforms/85xx/twr_p102x.c            |  4 +-
> > arch/powerpc/platforms/Kconfig                     | 19 ---------
> > arch/powerpc/sysdev/Makefile                       |  1 -
> > arch/powerpc/sysdev/qe_lib/Kconfig                 | 27 -------------
> > drivers/net/ethernet/freescale/fsl_pq_mdio.c       |  2 +-
> > drivers/net/ethernet/freescale/ucc_geth.c          |  8 ++--
> > drivers/net/ethernet/freescale/ucc_geth.h          |  8 ++--
> > drivers/soc/Kconfig                                |  2 +
> > drivers/soc/Makefile                               |  1 +
> > drivers/soc/fsl-qe/Kconfig                         | 45
> ++++++++++++++++++++++
> > .../sysdev/qe_lib => drivers/soc/fsl-qe}/Makefile  |  0
> > .../sysdev/qe_lib => drivers/soc/fsl-qe}/gpio.c    |  2 +-
> > .../sysdev/qe_lib => drivers/soc/fsl-qe}/qe.c      |  4 +-
> > .../sysdev/qe_lib => drivers/soc/fsl-qe}/qe_ic.c   |  2 +-
> > .../sysdev/qe_lib => drivers/soc/fsl-qe}/qe_ic.h   |  2 +-
> > .../sysdev/qe_lib => drivers/soc/fsl-qe}/qe_io.c   |  2 +-
> > .../sysdev/qe_lib => drivers/soc/fsl-qe}/ucc.c     |  6 +--
> > .../qe_lib => drivers/soc/fsl-qe}/ucc_fast.c       |  8 ++--
> > .../qe_lib => drivers/soc/fsl-qe}/ucc_slow.c       |  8 ++--
> > .../sysdev/qe_lib => drivers/soc/fsl-qe}/usb.c     |  4 +-
> > drivers/spi/spi-fsl-cpm.c                          |  2 +-
> > drivers/tty/serial/ucc_uart.c                      |  2 +-
> > drivers/usb/gadget/fsl_qe_udc.c                    |  2 +-
> > drivers/usb/host/fhci-hcd.c                        |  2 +-
> > drivers/usb/host/fhci-hub.c                        |  2 +-
> > drivers/usb/host/fhci-sched.c                      |  2 +-
> > drivers/usb/host/fhci.h                            |  4 +-
> > .../include/asm => include/linux/fsl}/immap_qe.h   |  0
> > .../powerpc/include/asm => include/linux/fsl}/qe.h |  2 +-
> > .../include/asm => include/linux/fsl}/qe_ic.h      |  0
> > .../include/asm => include/linux/fsl}/ucc.h        |  4 +-
> > .../include/asm => include/linux/fsl}/ucc_fast.h   |  6 +--
> > .../include/asm => include/linux/fsl}/ucc_slow.h   |  6 +--
> > 44 files changed, 112 insertions(+), 113 deletions(-) delete mode
> > 100644 arch/powerpc/sysdev/qe_lib/Kconfig
> > create mode 100644 drivers/soc/fsl-qe/Kconfig rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/Makefile (100%)
> > rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/gpio.c (99%)
> > rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/qe.c (99%)
> > rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/qe_ic.c
> > (99%) rename {arch/powerpc/sysdev/qe_lib =>
> > drivers/soc/fsl-qe}/qe_ic.h (98%) rename {arch/powerpc/sysdev/qe_lib
> > => drivers/soc/fsl-qe}/qe_io.c (99%) rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/ucc.c (98%) rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/ucc_fast.c (98%)
> > rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/ucc_slow.c
> > (98%) rename {arch/powerpc/sysdev/qe_lib => drivers/soc/fsl-qe}/usb.c
> > (96%) rename {arch/powerpc/include/asm =>
> > include/linux/fsl}/immap_qe.h (100%) rename {arch/powerpc/include/asm
> > => include/linux/fsl}/qe.h (99%) rename {arch/powerpc/include/asm =>
> > include/linux/fsl}/qe_ic.h (100%) rename {arch/powerpc/include/asm =>
> > include/linux/fsl}/ucc.h (96%) rename {arch/powerpc/include/asm =>
> > include/linux/fsl}/ucc_fast.h (98%) rename {arch/powerpc/include/asm
> > => include/linux/fsl}/ucc_slow.h (99%)
> 
> 
> So you should be moving things to drivers/soc/fsl/qe/ not
> drivers/soc/fsl-qe/
> 
> The headers should be in include/soc/fsl, not include/linux/fsl

I don't understand why I need to put headers in include/soc/fsl,
Can you explain more?

> 
> In addition before this move is accepted, other changes need to be made
> to convert to using standard frameworks for various functionality in QE
> lib.
> 
> 1. gpio.c -> needs to be converted to GPIO framework and placed in
> drivers/gpio 2. qe_ic* should probably move into drivers/irqchip 3.
> qe_io.c should be converted over to pinmux and put in drivers/pinctrl 4.
> Some of the clock could should be looked to be converted to use the clk
> framework
> 
> These changes need to be addressed before any of the qe_lib code can get
> moved into drivers/soc
> 
> - k

Best Regards
Zhao Qiang
