Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbaIWSmB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:42:01 -0400
Received: from mail-bl2on0131.outbound.protection.outlook.com ([65.55.169.131]:5984
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752593AbaIWSl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:41:59 -0400
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Sitsofe Wheeler <sitsofe@gmail.com>,
        "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to BUG_ON()
Thread-Topic: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to BUG_ON()
Thread-Index: AQHPw1r3Zanm1nEhm0a/E/TjkVvBiZwCoZ8QgAyTdjA=
Date: Tue, 23 Sep 2014 18:41:57 +0000
Message-ID: <cb4fc02e82d54bf392a15b9fa332734c@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1409181905-23254-1-git-send-email-kys@microsoft.com>
 <20140829072918.GA842@sucs.org>
 <d03e1a5aff0a4b28a447b3db3bf54f78@BY2PR0301MB0711.namprd03.prod.outlook.com>
In-Reply-To: <d03e1a5aff0a4b28a447b3db3bf54f78@BY2PR0301MB0711.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e8:ee31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0709;
x-forefront-prvs: 0343AC1D30
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(24454002)(51704005)(377454003)(13464003)(74662003)(1511001)(120916001)(95666004)(2561002)(77982003)(107046002)(83322001)(46102003)(19580405001)(80022003)(74502003)(4396001)(79102003)(99286002)(81542003)(2656002)(105586002)(108616004)(19580395003)(77096002)(81342003)(21056001)(15202345003)(92566001)(54356999)(33646002)(85852003)(106356001)(86362001)(90102001)(76576001)(31966008)(2421001)(101416001)(87936001)(76176999)(20776003)(97736003)(64706001)(15975445006)(50986999)(106116001)(76482002)(99396002)(86612001)(74316001)(83072002)(85306004)(10300001)(3826002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of KY Srinivasan
> Sent: Monday, September 15, 2014 11:39 AM
> To: Sitsofe Wheeler
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; jasowang@redhat.com;
> linux-kernel@vger.kernel.org; apw@canonical.com;
> devel@linuxdriverproject.org
> Subject: RE: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to BUG_ON()
> 
> 
> 
> > -----Original Message-----
> > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > Sent: Friday, August 29, 2014 12:29 AM
> > To: KY Srinivasan
> > Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; Dexuan Cui
> > Subject: Re: [PATCH V2 0/5] Drivers: hv: vmbus: Eliminate calls to
> > BUG_ON()
> >
> > On Wed, Aug 27, 2014 at 04:25:05PM -0700, K. Y. Srinivasan wrote:
> > > Cleanup the channel management code and eliminate calls to BUG_ON().
> > > Also fix an error propagation bug in vmbus_open().
> > >
> > > In this version of the patch-set, I have addressed comments from Dan
> > > Carpenter.
> > >
> > > K. Y. Srinivasan (5):
> > >   Drivers: hv: vmbus: Cleanup vmbus_post_msg()
> > >   Drivers: hv: vmbus: Cleanup vmbus_teardown_gpadl()
> > >   Drivers: hv: vmbus: Cleanup vmbus_close_internal()
> > >   Drivers: hv: vmbus: Cleanup vmbus_establish_gpadl()
> > >   Drivers: hv: vmbus: Fix a bug in vmbus_open()
> >
> > This patch set resolves a number of BUG_ON crashes I was hitting on
> > Hyper- V while booting a kernel with verification options on. With
> > these I can complete a 3.17.0-rc2 boot on an SMP setup although
> > patches from
> > "Drivers: hv: vmbus: Miscellaneous cleanup" are needed to resolve
> > other non-crash issues.
> >
> > Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
> 
> Greg,
> 
> Just checking if I should resend this patch-set. I have also sent a few patches
> after this.
> Please let me know.

Ping.

K. Y
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
