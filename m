Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaIXL3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:29:24 -0400
Received: from mail-bn1bon0136.outbound.protection.outlook.com ([157.56.111.136]:30420
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbaIXL3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:29:21 -0400
Date: Wed, 24 Sep 2014 19:29:05 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <balbi@ti.com>, Antoine Tenart <antoine.tenart@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <sebastian.hesselbarth@gmail.com>, <p.zabel@pengutronix.de>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alexandre.belloni@free-electrons.com>,
        <jszhang@marvell.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140924112902.GA23331@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <20140924022736.GA5307@peterchendt> <2990737.4KzKXPZhaB@wuerfel>
 <2923729.dtX0WmHSV0@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2923729.dtX0WmHSV0@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(52314003)(164054003)(24454002)(51704005)(189002)(199003)(50466002)(74502003)(106466001)(107046002)(64706001)(85852003)(23726002)(31966008)(33716001)(84676001)(21056001)(105606002)(110136001)(104016003)(20776003)(74662003)(97736003)(47776003)(81342003)(81542003)(77982003)(80022003)(95666004)(90102001)(10300001)(76482002)(93886004)(79102003)(120916001)(85306004)(87936001)(33656002)(68736004)(83506001)(83072002)(97756001)(54356999)(46102003)(83322001)(4396001)(44976005)(46406003)(6806004)(76176999)(92566001)(57986006)(50986999)(99396003)(92726001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0723;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:30:41AM +0200, Arnd Bergmann wrote:
> On Wednesday 24 September 2014 09:44:19 Arnd Bergmann wrote:
> > 
> > We can also gradually move in some of the other glue drivers into
> > the main driver if the differences are small enough.
> > 
> 
> FWIW, I've just looked at the other glue drivers that already
> exist:
> 
> - zevio can just get merged into the common driver, all that seems
>   to be needed for that is the additional compatible string, and
>   keying off the ci_default_zevio_platdata on the .data field of
>   the of_device_id table.
> 
> - msm has a custom notifier, which justifies leaving it in a separate
>   driver, but it's also small enough that it wouldn't hurt to have
>   that merged into the main driver too.
> 
> - imx requires a lot of other things, in particular the dependency
>   on the usbmisc driver means we don't want to have that in the
>   core anyway, so we can't really merge that in.
> 
> - the proposed ar933x driver again looks almost trivial, so no reason
>   for a separate glue driver for that.
> 
> 	Arnd

Thanks, Arnd.

So, it is IP CORE LIB (you suggest) vs IP CORE Platform Driver
(dwc3, musb, chipidea) you are talking about, right? Except for
creating another platform driver as well as related DT node (optional),
are there any advantages compared to current IP core driver structure?

In this thread, we are talking about creating common platform driver for glue
layer, its design purpose (adapt it for as many as platforms) should be the
same, no matter the IP core part is a LIB or platform driver, am I missing
something?

-- 
Best Regards,
Peter Chen
