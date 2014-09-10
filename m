Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaIJDiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:38:24 -0400
Received: from mail-bn1bon0144.outbound.protection.outlook.com ([157.56.111.144]:57984
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750719AbaIJDiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:38:22 -0400
X-Greylist: delayed 64590 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 23:38:22 EDT
From: "qiang.zhao@freescale.com" <qiang.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: "LeoLi@freescale.com" <LeoLi@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Xiaobo Xie <X.Xie@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
Thread-Topic: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
Thread-Index: AQHPx/38+xbLVfMsRkK3ZAlSNrGVXZvxlD2AgAb4GQCAAO6vAIAARQ9Q
Date: Wed, 10 Sep 2014 03:38:18 +0000
Message-ID: <fcf0691e6fe7410bb72ddb459da9a315@BLUPR03MB341.namprd03.prod.outlook.com>
References: <1409807186-45816-1-git-send-email-B45475@freescale.com>
	 <1409870809.24184.163.camel@snotra.buserror.net>
	 <88ded7369c0546aabeececed5f1a4c06@BLUPR03MB341.namprd03.prod.outlook.com>
 <1410305198.24184.336.camel@snotra.buserror.net>
In-Reply-To: <1410305198.24184.336.camel@snotra.buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019019)(6009001)(377424004)(189002)(199003)(24454002)(377454003)(51704005)(99286002)(33646002)(50986999)(106356001)(90102001)(93886004)(85306004)(77982001)(101416001)(106116001)(2656002)(76482001)(74502001)(110136001)(31966008)(95666004)(107046002)(74662001)(86362001)(46102001)(83322001)(99396002)(87936001)(79102001)(20776003)(54356999)(92566001)(76176999)(85852003)(4396001)(83072002)(64706001)(19580395003)(19580405001)(21056001)(76576001)(81342001)(66066001)(74316001)(81542001)(80022001)(108616004)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0724;H:BLUPR03MB341.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8A3cSo4012227

On Wed, 2014-09-10 at 07:27 -0500, Wood Scott-B07421 wrote:

> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Wednesday, September 10, 2014 7:27 AM
> To: Zhao Qiang-B45475
> Cc: Li Yang-Leo-R58472; linuxppc-dev@lists.ozlabs.org; Xie Xiaobo-R63061;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
> 
> On Tue, 2014-09-09 at 04:27 -0500, Zhao Qiang-B45475 wrote:
> > On Fri, 2014-09-05 at 06:47 AM, Wood Scott wrote:
> >
> >
> >
> > > Subject: Re: [PATCH v2] QE: move qe code from arch/powerpc to
> > > drivers/soc
> > >
> > > On Thu, 2014-09-04 at 13:06 +0800, Zhao Qiang wrote:
> > > > LS1 is arm cpu and it has qe ip block.
> > > > move qe code from platform directory to public directory.
> > > >
> > > > QE is an IP block integrates several comunications peripheral
> > > > controllers. It can implement a variety of applications, such as
> > > > uart, usb and tdm and so on.
> > > >
> > > > Signed-off-by: Zhao Qiang <B45475@freescale.com>
> > > > ---
> > > > Changes for v2:
> > > > 	- mv code to drivers/soc
> > >
> > > Who will be the maintainer of this code once it lives in
> > > drivers/soc, especially once it is no longer used only by PPC?
> >
> > I have no idea about that, can you explain why you want to know who
> will be the maintainer.
> 
> Currently it falls within "Freescale PPC" which I maintain.  This moves
> it out of arch/powerpc and is the first step towards making it not be
> PPC-specific.  Whose tree are you expecting patches to drivers/soc/fsl-qe
> to go through?

How about network tree?

> 
> > > > diff --git a/drivers/soc/qe/Kconfig b/drivers/soc/qe/Kconfig new
> > > > file mode 100644 index 0000000..8b03ca2
> > > > --- /dev/null
> > > > +++ b/drivers/soc/qe/Kconfig
> > > > @@ -0,0 +1,45 @@
> > > > +#
> > > > +# QE Communication options
> > > > +#
> > > > +config QUICC_ENGINE
> > > > +	bool "Freescale QUICC Engine (QE) Support"
> > > > +	depends on FSL_SOC && PPC32
> > > > +	select PPC_LIB_RHEAP
> > > > +	select CRC32
> > > > +	help
> > > > +	  The QUICC Engine (QE) is a new generation of communications
> > > > +	  coprocessors on Freescale embedded CPUs (akin to CPM in
> older
> > > chips).
> > > > +	  Selecting this option means that you wish to build a kernel
> > > > +	  for a machine with a QE coprocessor.
> > > > +
> > > > +config QE_GPIO
> > > > +	bool "QE GPIO support"
> > > > +	depends on QUICC_ENGINE
> > > > +	select ARCH_REQUIRE_GPIOLIB
> > > > +	help
> > > > +	  Say Y here if you're going to use hardware that connects to
> the
> > > > +	  QE GPIOs.
> > > > +
> > > > +config UCC_SLOW
> > > > +	bool
> > > > +	default y if SERIAL_QE
> > > > +	help
> > > > +	  This option provides qe_lib support to UCC slow
> > > > +	  protocols: UART, BISYNC, QMC
> > > > +
> > > > +config UCC_FAST
> > > > +	bool
> > > > +	default y if UCC_GETH
> > > > +	help
> > > > +	  This option provides qe_lib support to UCC fast
> > > > +	  protocols: HDLC, Ethernet, ATM, transparent
> > > > +
> > > > +config UCC
> > > > +	bool
> > > > +	default y if UCC_FAST || UCC_SLOW
> > > > +
> > > > +config QE_USB
> > > > +	bool
> > > > +	default y if USB_FSL_QE
> > > > +	help
> > > > +	  QE USB Controller support
> > >
> > > First could we give these names better namespacing?
> >
> > Add FSL as prefix?
> 
> Yes.

If the names changed, there will be so a lot of changes.
Can I send another patch to change it?

> 
> -Scott
> 
Regards,
Zhao Qiang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
