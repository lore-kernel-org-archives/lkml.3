Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaIYA47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 20:56:59 -0400
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:16965
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232AbaIYA45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:56:57 -0400
Date: Thu, 25 Sep 2014 08:56:43 +0800
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
Message-ID: <20140925005641.GA3716@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <2923729.dtX0WmHSV0@wuerfel> <20140924112902.GA23331@peterchendt>
 <2786668.t3YLqX5enD@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2786668.t3YLqX5enD@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(189002)(54356999)(68736004)(79102003)(4396001)(83322001)(80022003)(106466001)(95666004)(64706001)(33656002)(92726001)(81342003)(46102003)(74662003)(47776003)(6806004)(97756001)(76176999)(85852003)(50986999)(97736003)(105606002)(83506001)(33716001)(74502003)(83072002)(77982003)(81542003)(86362001)(50466002)(85306004)(23726002)(44976005)(93886004)(90102001)(76482002)(92566001)(84676001)(120916001)(20776003)(21056001)(46406003)(10300001)(104016003)(107046002)(102836001)(87936001)(31966008)(99396003)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Forefront-PRVS: 0345CFD558
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 02:23:38PM +0200, Arnd Bergmann wrote:
> On Wednesday 24 September 2014 19:29:05 Peter Chen wrote:
> > 
> > So, it is IP CORE LIB (you suggest) vs IP CORE Platform Driver
> > (dwc3, musb, chipidea) you are talking about, right? Except for
> > creating another platform driver as well as related DT node (optional),
> > are there any advantages compared to current IP core driver structure?
> 
> Having a library module usually requires less code, and is more consistent
> with other drivers, which helps new developers understand what the
> driver is doing.

Yes, more consistent is a good reason.

> 
> The most important aspect though is the DT binding: once the structure
> with separate kernel drivers leaks out into the DT format, you can't
> easily change the driver any more, e.g. to make a property that was
> introduced for one glue driver more general so it can get handled by
> the common part. Having a single node lets us convert to the library
> model later, so that would be a strong reason to keep the DT binding
> simple, without child nodes.
> 
> Following that logic, it turns into another reason for using the library
> model to start with, because otherwise the child device does not have
> any DT properties itself and has to rely on the parent device properties,
> which somewhat complicates the driver structure.
> 

Although it is not a problem for chipidea, chipidea core exports API
to handle parent's common DT entries. It is a little inconsistent for
current chipidea core driver, it works as a driver, but exports some
APIs for other drivers use which is like a library. One more benefit I
can see is the platform driver can visit the common struct like io
address if using library, currently, the platform driver isn't suitable
to visit core driver's struct, since they are two drivers.

For chipidea, it doesn't has child device DT node, so it can convert to
core library + platform driver model with moderate effort, I will do
it at next two versions, thanks.

-- 
Best Regards,
Peter Chen
