Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaIJBBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:01:13 -0400
Received: from mail-by2on0120.outbound.protection.outlook.com ([207.46.100.120]:35232
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751176AbaIJBBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:01:11 -0400
X-Greylist: delayed 3587 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 21:01:11 EDT
Message-ID: <1410305198.24184.336.camel@snotra.buserror.net>
Subject: Re: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
From: Scott Wood <scottwood@freescale.com>
To: Zhao Qiang-B45475 <qiang.zhao@freescale.com>
CC: Li Yang-Leo-R58472 <LeoLi@freescale.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Xie Xiaobo-R63061 <X.Xie@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 9 Sep 2014 18:26:38 -0500
In-Reply-To: <88ded7369c0546aabeececed5f1a4c06@BLUPR03MB341.namprd03.prod.outlook.com>
References: <1409807186-45816-1-git-send-email-B45475@freescale.com>
	 <1409870809.24184.163.camel@snotra.buserror.net>
	 <88ded7369c0546aabeececed5f1a4c06@BLUPR03MB341.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:15c7:8cb:bf57:fe1a]
X-ClientProxiedBy: BN3PR0301CA0044.namprd03.prod.outlook.com (25.160.152.140)
 To BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019019)(6009001)(24454002)(189002)(377424004)(199003)(51704005)(377454003)(87286001)(107046002)(83072002)(20776003)(47776003)(85852003)(50466002)(88136002)(64706001)(85306004)(106356001)(105586002)(79102001)(93916002)(86362001)(23676002)(62966002)(74662001)(89996001)(97736003)(19580405001)(19580395003)(92566001)(83322001)(33646002)(104166001)(77982001)(74502001)(80022001)(76482001)(81342001)(90102001)(21056001)(110136001)(42186005)(87976001)(92726001)(95666004)(50986999)(31966008)(77096002)(76176999)(4396001)(99396002)(103116003)(50226001)(102836001)(77156001)(46102001)(81542001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:15c7:8cb:bf57:fe1a];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 04:27 -0500, Zhao Qiang-B45475 wrote:
> On Fri, 2014-09-05 at 06:47 AM, Wood Scott wrote:
> 
> 
> 
> > Subject: Re: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
> > 
> > On Thu, 2014-09-04 at 13:06 +0800, Zhao Qiang wrote:
> > > LS1 is arm cpu and it has qe ip block.
> > > move qe code from platform directory to public directory.
> > >
> > > QE is an IP block integrates several comunications peripheral
> > > controllers. It can implement a variety of applications, such as uart,
> > > usb and tdm and so on.
> > >
> > > Signed-off-by: Zhao Qiang <B45475@freescale.com>
> > > ---
> > > Changes for v2:
> > > 	- mv code to drivers/soc
> > 
> > Who will be the maintainer of this code once it lives in drivers/soc,
> > especially once it is no longer used only by PPC?
> 
> I have no idea about that, can you explain why you want to know who will be the maintainer.

Currently it falls within "Freescale PPC" which I maintain.  This moves
it out of arch/powerpc and is the first step towards making it not be
PPC-specific.  Whose tree are you expecting patches to
drivers/soc/fsl-qe to go through?

> > > diff --git a/drivers/soc/qe/Kconfig b/drivers/soc/qe/Kconfig new file
> > > mode 100644 index 0000000..8b03ca2
> > > --- /dev/null
> > > +++ b/drivers/soc/qe/Kconfig
> > > @@ -0,0 +1,45 @@
> > > +#
> > > +# QE Communication options
> > > +#
> > > +config QUICC_ENGINE
> > > +	bool "Freescale QUICC Engine (QE) Support"
> > > +	depends on FSL_SOC && PPC32
> > > +	select PPC_LIB_RHEAP
> > > +	select CRC32
> > > +	help
> > > +	  The QUICC Engine (QE) is a new generation of communications
> > > +	  coprocessors on Freescale embedded CPUs (akin to CPM in older
> > chips).
> > > +	  Selecting this option means that you wish to build a kernel
> > > +	  for a machine with a QE coprocessor.
> > > +
> > > +config QE_GPIO
> > > +	bool "QE GPIO support"
> > > +	depends on QUICC_ENGINE
> > > +	select ARCH_REQUIRE_GPIOLIB
> > > +	help
> > > +	  Say Y here if you're going to use hardware that connects to the
> > > +	  QE GPIOs.
> > > +
> > > +config UCC_SLOW
> > > +	bool
> > > +	default y if SERIAL_QE
> > > +	help
> > > +	  This option provides qe_lib support to UCC slow
> > > +	  protocols: UART, BISYNC, QMC
> > > +
> > > +config UCC_FAST
> > > +	bool
> > > +	default y if UCC_GETH
> > > +	help
> > > +	  This option provides qe_lib support to UCC fast
> > > +	  protocols: HDLC, Ethernet, ATM, transparent
> > > +
> > > +config UCC
> > > +	bool
> > > +	default y if UCC_FAST || UCC_SLOW
> > > +
> > > +config QE_USB
> > > +	bool
> > > +	default y if USB_FSL_QE
> > > +	help
> > > +	  QE USB Controller support
> > 
> > First could we give these names better namespacing?
> 
> Add FSL as prefix?

Yes.

-Scott


