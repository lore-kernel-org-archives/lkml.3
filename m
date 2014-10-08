Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaJHD0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 23:26:16 -0400
Received: from mail-bl2on0101.outbound.protection.outlook.com ([65.55.169.101]:55660
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753881AbaJHD0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 23:26:15 -0400
From: Hongtao Jia <hongtao.jia@freescale.com>
To: Scott Wood <scottwood@freescale.com>, Guenter Roeck <linux@roeck-us.net>
CC: Jojy Varghese <jojyv@juniper.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@juniper.net>
Subject: RE: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Topic: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
Thread-Index: AQHP3AVDC3AT59iZz0+7oSg9BNxjZpwYcGoAgAAIjoCAAEIxgIAAB64AgAERooCAAJTtAIALKTlw
Date: Wed, 8 Oct 2014 03:10:32 +0000
Message-ID: <c402851215544e58a8b0bdaabde79395@BLUPR03MB149.namprd03.prod.outlook.com>
References: <D04F3201.10DEB%jojyv@juniper.net>
	 <1412033466.13320.293.camel@snotra.buserror.net>
	 <20140930155029.GA4724@roeck-us.net>
 <1412124210.13320.330.camel@snotra.buserror.net>
In-Reply-To: <1412124210.13320.330.camel@snotra.buserror.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0735;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(199003)(51704005)(189002)(377424004)(377454003)(479174003)(24454002)(105586002)(106356001)(80022003)(86362001)(106116001)(76176999)(46102003)(50986999)(87936001)(95666004)(21056001)(33646002)(92566001)(108616004)(93886004)(85306004)(120916001)(76482002)(64706001)(97736003)(31966008)(85852003)(4396001)(19580405001)(20776003)(77096002)(66066001)(74316001)(99396003)(2656002)(101416001)(19580395003)(107046002)(54356999)(122556002)(40100002)(7059024)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0735;H:BLUPR03MB149.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s983QLom022066



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Wednesday, October 01, 2014 8:44 AM
> To: Guenter Roeck
> Cc: Jojy Varghese; Benjamin Herrenschmidt; Paul Mackerras; Michael
> Ellerman; linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> Guenter Roeck; Jia Hongtao-B38951
> Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
> exception on E500MC / E5500
> 
> On Tue, 2014-09-30 at 08:50 -0700, Guenter Roeck wrote:
> > On Mon, Sep 29, 2014 at 06:31:06PM -0500, Scott Wood wrote:
> > > On Mon, 2014-09-29 at 23:03 +0000, Jojy Varghese wrote:
> > > >
> > > > On 9/29/14 12:06 PM, "Guenter Roeck" <linux@roeck-us.net> wrote:
> > > >
> > > > >Those are errors related to PCIe hotplug, and are seen with
> > > > >unexpected PCIe device removals (triggered, for example, by
> > > > >removing power from a PCIe adapter).
> > > > >The behavior we see on E5500 is quite similar to the same
> > > > >behavior on
> > > > >E500:
> > > > >If unhandled, the CPU keeps executing the same instruction over
> > > > >and over again if there is an error on a PCIe access and thus
> > > > >stalls. I don't know if this is considered an erratum or expected
> > > > >behavior, but it is one we have to address since we have to be
> > > > >able to handle that condition.
> > >
> > > The reason I ask is that the handling for e500 was described as an
> > > erratum workaround.  If it is an erratum it would be nice to know
> > > the erratum number and the full list of affected chips.
> > >
> > My understanding, which may be wrong, was that this is expected
> > behavior, at least for E5500. I actually thought I had seen it
> > somewhere in the specification (response to PCIe errors), but I don't
> recall where exactly.
> >
> > At least for my part I am not aware of an erratum.
> 
> Jia Hongtao, can you comment here?

I did not find any related erratum either.

> 
> > > > >Ultimately, we'll want
> > > > >to
> > > > >implement PCIe error handlers for the affected drivers, but that
> > > > >will be a next step.
> > >
> > > For now can we at least print a ratelimited error message?  I don't
> > > like the idea of silently ignoring these errors.  I suppose it's a
> > > separate issue from extending the workaround to cover e500mc, though.
> > >
> > I don't really like the idea of printing an error message pretty much
> > each time when an unexpected hotplug event occurs.
> 
> Unexpected events seem like the sort of thing you'd want to log, but my
> concern is that this might not be the only cause of PCI errors.
> 
> -Scott
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
