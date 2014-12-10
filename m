Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660AbaLJRue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:50:34 -0500
Received: from mail-bl2on0148.outbound.protection.outlook.com ([65.55.169.148]:1728
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932268AbaLJRub convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:50:31 -0500
From: KY Srinivasan <kys@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor cleanup
Thread-Topic: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
 cleanup
Thread-Index: AQHQFFrYQn9sLeYHTkGJVVcMPaRhsZyI6AKAgAAyiWA=
Date: Wed, 10 Dec 2014 17:50:23 +0000
Message-ID: <BY2PR0301MB071102AF97B27F11EF91F89CA0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
 <F792CF86EFE20D4AB8064279AFBA51C613E9B62F@SIXPRD3002MB028.064d.mgd.msft.net>
 <87lhmfhna7.fsf@vitty.brq.redhat.com> <20141210144829.GB17184@kroah.com>
In-Reply-To: <20141210144829.GB17184@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0775;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0775;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(24454002)(51914003)(13464003)(377454003)(43544003)(189002)(199003)(64706001)(20776003)(107046002)(99286002)(97736003)(74316001)(105586002)(21056001)(120916001)(2501002)(99396003)(54206007)(106356001)(122556002)(40100003)(92566001)(76176999)(50986999)(54356999)(76576001)(54606007)(101416001)(87936001)(2656002)(106116001)(77156002)(62966003)(33656002)(93886004)(46102003)(4396001)(86362001)(19580395003)(102836002)(19580405001)(68736005)(1720100001)(86612001)(31966008)(15975445007)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0775;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of gregkh@linuxfoundation.org
> Sent: Wednesday, December 10, 2014 6:48 AM
> To: Vitaly Kuznetsov
> Cc: devel@linuxdriverproject.org; Haiyang Zhang; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
> cleanup
> 
> On Wed, Dec 10, 2014 at 10:22:40AM +0100, Vitaly Kuznetsov wrote:
> > Dexuan Cui <decui@microsoft.com> writes:
> >
> > >> -----Original Message-----
> > >> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> > >> Sent: Tuesday, December 9, 2014 23:48 PM
> > >> To: KY Srinivasan
> > >> Cc: Haiyang Zhang; devel@linuxdriverproject.org; linux-
> > >> kernel@vger.kernel.org; Dexuan Cui
> > >> Subject: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor
> > >> cleanup
> > >>
> > >> When someone does 'make' in tools/hv/ issues appear:
> > >> - hv_fcopy_daemon is not being built;
> > >> - lots of compiler warnings.
> > >>
> > >> This is just a cleanup. Compile-tested by myself on top of linux-
> next/master.
> > >>
> > >> Piggyback this series and send "[PATCH 5/5] Tools: hv: do not add
> > >> redundant '/'
> > >>  in hv_start_fcopy()"
> > >>
> > >> Vitaly Kuznetsov (5):
> > >>   Tools: hv: add mising fcopyd to the Makefile
> > >>   Tools: hv: remove unused bytes_written from kvp_update_file()
> > >>   Tools: hv: address compiler warnings for hv_kvp_daemon.c
> > >>   Tools: hv: address compiler warnings for hv_fcopy_daemon.c
> > >>   Tools: hv: do not add redundant '/' in hv_start_fcopy()
> > >>
> > >>  tools/hv/Makefile          |  4 ++--
> > >>  tools/hv/hv_fcopy_daemon.c | 10 ++--------
> > >>  tools/hv/hv_kvp_daemon.c   | 29 +++++++++++++----------------
> > >>  3 files changed, 17 insertions(+), 26 deletions(-)
> > >>
> > >> --
> > >> 1.9.3
> > >
> > > Hi Vitaly,
> > > Thanks for the patchset!
> > >
> > > Acked-by: Dexuan Cui <decui@microsoft.com>
> > >
> > > PS, I added Greg into the TO list.
> > > The hv code in drivers/hv/ and tools/hv/ usually has to go into
> > > Greg's tree first.
> >
> > Well, I don't mind spamming Greg but he's not on the
> > scripts/get_maintainer.pl output. In case he's not monitoring the list
> > for patches by some other tool (patchwork?) a patch adding him to
> > MAINTAINERS would do the job.
> >
> > Greg, do you want to become an official Hyper-V maintainer in
> > MAINTAINERS? I can send a patch then :-)
> 
> No.  It's up to the "real" maintainers to take the patches and then forward
> them on to me for inclusion in the kernel tree.  KY knows this...

I will take care of this.

K. Y
> 
> thanks,
> 
> greg k-h
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
