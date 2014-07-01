Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbaGAHng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:43:36 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:14567
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752886AbaGAHne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:43:34 -0400
Date: Tue, 1 Jul 2014 15:42:56 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Rob Herring <robherring2@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nadav Haklai <nadavh@marvell.com>, Lior Amsalem <alior@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 0/5] ARM: Centralize the access to the SCU register
Message-ID: <20140701074255.GF14471@dragon>
References: <1403822608-31158-1-git-send-email-gregory.clement@free-electrons.com>
 <CAL_JsqL9w0oxxM0zTAVioh0Uf3PNO3TfhxzOLV6KhBOoS4Fdiw@mail.gmail.com>
 <53ACA62F.1090802@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53ACA62F.1090802@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199002)(189002)(21056001)(97756001)(97736001)(76176999)(54356999)(81542001)(81342001)(99396002)(46406003)(50986999)(74502001)(57986006)(74662001)(102836001)(31966008)(80022001)(85306003)(64706001)(44976005)(83322001)(68736004)(69596002)(6806004)(33716001)(20776003)(47776003)(83506001)(84676001)(23726002)(26826002)(50466002)(92726001)(92566001)(86362001)(104016002)(95666004)(33656002)(107046002)(77982001)(76482001)(83072002)(85852003)(79102001)(106466001)(81156004)(105606002)(46102001)(4396001)(87936001);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB093;H:az84smr01.freescale.net;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02596AB7DA
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 01:01:03AM +0200, Gregory CLEMENT wrote:
> >> The last patch removed a direct access to the SCU register by an
> >> access through the new scu_standby_enable() function. For this one I
> >> have just checked that the kernel can be built using the
> >> imx_v6_v7_defconfig config, but I didn't test it on an imx6 hardware.
> > 
> > Why would we not just turn on these 2 features unconditionally? If we
> 
> You mean in scu_enbale() ?
> 
> > don't know of any platform where they are broken, then we should just
> 
> At least on some imx6 SCU standby is broken according to the code and
> the comments.

Hi Gregory,

What's broken on particular revisions of some i.MX6 SoC is WAIT mode
support, not SCU standby.  I think the SCU standby can just be
unconditionally enabled in scu_enbale().

Shawn
