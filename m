Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbaDBUw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:52:26 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:37298
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933024AbaDBUwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:52:24 -0400
From: Insop Song <Insop.Song@gainspeed.com>
To: Greg KH <gregkh@linuxfoundation.org>, Paul Bolle <pebolle@tiscali.nl>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'insop.song@gmail.com'" <insop.song@gmail.com>
Subject: RE: [GIT PULL] Staging driver patches for 3.15-rc1
Thread-Topic: [GIT PULL] Staging driver patches for 3.15-rc1
Thread-Index: AQHPTkzq5stqiKD3K0ydjMfEGOTZTZr+wOcAgAAIFcA=
Date: Wed, 2 Apr 2014 20:52:18 +0000
Message-ID: <7731bd53be4b49e2924a7002f74dc090@BY2PR07MB011.namprd07.prod.outlook.com>
References: <20140401184817.GA21855@kroah.com>
 <1396427043.18431.20.camel@x220> <20140402200428.GE26966@kroah.com>
In-Reply-To: <20140402200428.GE26966@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [108.60.97.2]
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(24454002)(51704005)(189002)(199002)(377454003)(377424004)(54316002)(85306002)(56776001)(83072002)(94946001)(81686001)(99286001)(90146001)(81542001)(81816001)(87266001)(51856001)(54356001)(80022001)(2656002)(53806001)(74876001)(83322001)(86362001)(98676001)(93516002)(93136001)(46102001)(85852003)(77096001)(63696002)(76796001)(31966008)(74662001)(79102001)(47976001)(4396001)(74502001)(69226001)(20776003)(94316002)(92566001)(59766001)(76786001)(87936001)(81342001)(50986001)(76576001)(65816001)(74316001)(77982001)(74706001)(47446002)(66066001)(47736001)(56816005)(33646001)(80976001)(95666003)(49866001)(74366001)(95416001)(97336001)(97186001)(99396002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB011;H:BY2PR07MB011.namprd07.prod.outlook.com;FPR:FFDC74D6.2CF24C6A.F1E19037.8EE1DDF8.202F3;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: gainspeed.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, April 02, 2014 1:04 PM, Greg KH wrote:
> On Wed, Apr 02, 2014 at 10:24:03AM +0200, Paul Bolle wrote:
> > On Tue, 2014-04-01 at 11:48 -0700, Greg KH wrote:
> > > Staging driver pull request for 3.15-rc1
> > >
> > > Here's the huge drivers/staging/ update for 3.15-rc1.
> > >
> > > Loads of cleanup fixes, a few drivers removed, and some new ones
> added.
> > >
> > > All have been in linux-next for a while.
> > >
> > >[...]
> > >
> > > Insop Song (1):
> > >       staging: fpgaboot: Xilinx FPGA firmware download driver
> >
> > This commit adds checks for CONFIG_B4860G100. Is a patch to add a
> > Kconfig symbol B4860G100 perhaps queued somewhere?
> 
> Insop, I thought this config option was coming from some other place, right?
> 

Paul,
I didn't include CONFIG_B4860G100 in Kconfig in original patch set, since programming FPGA method can vary in different system, and this was discussed during the review with Greg as well.

However, actual fpga programming method is well contained in io.c with ifdef-ed CONFIG_B4860G100, now I think I might better to update Kconfig to include CONFIG_B4860G100.

Greg, what do you think? Any harm to add custom board CONFIG* to staging Kconfig? Let me know.


> > It also adds this Makefile line:
> >     ccflags-$(CONFIG_GS_FPGA_DEBUG)    := -DDEBUG
> >
> > But there's no Kconfig symbol GS_FGPA_DEBUG. On the other hand, the
> > code involved doesn't seem to use either DEBUG or dev_dbg() so perhaps
> > it isn't actually needed. (But note that the code does check for
> > DEBUG_FPGA, which apparently has to be set manually.)
> 
> Odds are we can just drop this, patches gladly accepted :)
> 

I looked at it, and thank you for pointing that out.
They can be removed, as Greg said, patches are welcome :), or let me know if you are busy, then I can do that.

Thank you,

ISS
