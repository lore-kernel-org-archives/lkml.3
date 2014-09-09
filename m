Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaIIKAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:00:41 -0400
Received: from mail-bl2on0128.outbound.protection.outlook.com ([65.55.169.128]:26462
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753830AbaIIKAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:00:39 -0400
X-Greylist: delayed 1977 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 06:00:39 EDT
From: "qiang.zhao@freescale.com" <qiang.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Xiaobo Xie <X.Xie@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
Thread-Topic: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
Thread-Index: AQHPx/38+xbLVfMsRkK3ZAlSNrGVXZvxlD2AgAb4GQA=
Date: Tue, 9 Sep 2014 09:27:38 +0000
Message-ID: <88ded7369c0546aabeececed5f1a4c06@BLUPR03MB341.namprd03.prod.outlook.com>
References: <1409807186-45816-1-git-send-email-B45475@freescale.com>
 <1409870809.24184.163.camel@snotra.buserror.net>
In-Reply-To: <1409870809.24184.163.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 0329B15C8A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019018)(6009001)(377454003)(51704005)(189002)(199003)(377424004)(24454002)(21056001)(64706001)(83322001)(92566001)(86362001)(19580395003)(87936001)(85852003)(83072002)(19580405001)(54356999)(76176999)(80022001)(81342001)(97736003)(20776003)(74316001)(108616004)(81542001)(4396001)(76576001)(66066001)(85306004)(2656002)(105586002)(106116001)(101416001)(50986999)(33646002)(90102001)(99286002)(106356001)(74662001)(95666004)(46102001)(74502001)(99396002)(76482001)(77982001)(31966008)(79102001)(110136001)(107046002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0724;H:BLUPR03MB341.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s89A0k4t005250

On Fri, 2014-09-05 at 06:47 AM, Wood Scott wrote:



> Subject: Re: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
> 
> On Thu, 2014-09-04 at 13:06 +0800, Zhao Qiang wrote:
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
> > 	- mv code to drivers/soc
> 
> Who will be the maintainer of this code once it lives in drivers/soc,
> especially once it is no longer used only by PPC?

I have no idea about that, can you explain why you want to know who will be the maintainer.

> 
> >  44 files changed, 113 insertions(+), 113 deletions(-)  delete mode
> > 100644 arch/powerpc/sysdev/qe_lib/Kconfig
> >  create mode 100644 drivers/soc/qe/Kconfig  rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/Makefile (100%)  rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/gpio.c (99%)  rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe.c (99%)  rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_ic.c (99%)  rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_ic.h (98%)  rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_io.c (99%)  rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc.c (98%)  rename
> > {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc_fast.c (98%)
> > rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc_slow.c (98%)
> > rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/usb.c (96%)
> 
> drivers/soc/fsl-qe
> 
> > diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile index
> > 0f7c447..5da1a482 100644
> > --- a/drivers/soc/Makefile
> > +++ b/drivers/soc/Makefile
> > @@ -3,3 +3,5 @@
> >  #
> >
> >  obj-$(CONFIG_ARCH_QCOM)		+= qcom/
> > +
> > +obj-$(CONFIG_QUICC_ENGINE)     += qe/
> 
> Please keep the file consistent regarding tabs versus spaces.
> 
> Plus, why do you need a newline between them?

I will modify it in v3

> 
> > diff --git a/drivers/soc/qe/Kconfig b/drivers/soc/qe/Kconfig new file
> > mode 100644 index 0000000..8b03ca2
> > --- /dev/null
> > +++ b/drivers/soc/qe/Kconfig
> > @@ -0,0 +1,45 @@
> > +#
> > +# QE Communication options
> > +#
> > +config QUICC_ENGINE
> > +	bool "Freescale QUICC Engine (QE) Support"
> > +	depends on FSL_SOC && PPC32
> > +	select PPC_LIB_RHEAP
> > +	select CRC32
> > +	help
> > +	  The QUICC Engine (QE) is a new generation of communications
> > +	  coprocessors on Freescale embedded CPUs (akin to CPM in older
> chips).
> > +	  Selecting this option means that you wish to build a kernel
> > +	  for a machine with a QE coprocessor.
> > +
> > +config QE_GPIO
> > +	bool "QE GPIO support"
> > +	depends on QUICC_ENGINE
> > +	select ARCH_REQUIRE_GPIOLIB
> > +	help
> > +	  Say Y here if you're going to use hardware that connects to the
> > +	  QE GPIOs.
> > +
> > +config UCC_SLOW
> > +	bool
> > +	default y if SERIAL_QE
> > +	help
> > +	  This option provides qe_lib support to UCC slow
> > +	  protocols: UART, BISYNC, QMC
> > +
> > +config UCC_FAST
> > +	bool
> > +	default y if UCC_GETH
> > +	help
> > +	  This option provides qe_lib support to UCC fast
> > +	  protocols: HDLC, Ethernet, ATM, transparent
> > +
> > +config UCC
> > +	bool
> > +	default y if UCC_FAST || UCC_SLOW
> > +
> > +config QE_USB
> > +	bool
> > +	default y if USB_FSL_QE
> > +	help
> > +	  QE USB Controller support
> 
> First could we give these names better namespacing?

Add FSL as prefix?

> 
> -Scott
> 
Regards,
Zhao Qiang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
