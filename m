Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965288AbaH0XOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:14:10 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:34123
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965033AbaH0XOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:14:08 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: Dexuan Cui <decui@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjYjJn6yhiZAUmfcA+tXSCe25vhYa6AgAA9PQCAARoEAIABlgcAgAANEQCAAAyZgIAAIPwAgAAi6gCAABhF8IAAVx2AgAABQrA=
Date: Wed, 27 Aug 2014 23:13:47 +0000
Message-ID: <ec859d8c8f8743a0b72e5e578472f45d@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140820092630.GA1478@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C994F314@SINEX14MBXC417.southpacific.corp.microsoft.com>
 <20140825174132.GA17681@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827161900.GA25326@sucs.org>
 <51ae44fcae424365a6d78f3597175d77@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140827225739.GA24590@sucs.org>
In-Reply-To: <20140827225739.GA24590@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199003)(377454003)(189002)(13464003)(86612001)(87936001)(15395725005)(77982001)(15202345003)(79102001)(21056001)(101416001)(33646002)(106116001)(81342001)(92566001)(106356001)(105586002)(76176999)(85852003)(77096002)(81542001)(95666004)(76482001)(74316001)(99286002)(1411001)(54356999)(50986999)(15975445006)(83072002)(110136001)(99396002)(19580395003)(108616004)(74502001)(31966008)(74662001)(19580405001)(93886004)(4396001)(85306004)(83322001)(76576001)(80022001)(2656002)(90102001)(46102001)(107046002)(86362001)(64706001)(20776003)(7059011)(3826002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Wednesday, August 27, 2014 3:58 PM
> To: KY Srinivasan
> Cc: Dexuan Cui; Greg Kroah-Hartman; Haiyang Zhang;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org
> Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
> ffff880077800004 (hv_ringbuffer_write)
> 
> On Wed, Aug 27, 2014 at 06:45:55PM +0000, KY Srinivasan wrote:
> >
> > > -----Original Message-----
> > > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > > Sent: Wednesday, August 27, 2014 9:19 AM
> > >
> > > > BTW, with the patch below, hyperv_fb can work now, BUT,
> > > > *occasionally*,
> > > > storvsc_probe() -> ... -> vmbus_open() -> can fail due to
> > > > HV_STATUS_INVALID_ALIGNMENT...
> > >
> > > I applied your new patch on top of KY's pieces (it applied cleanly)
> > > and while it doesn't blow up, one warning is printed out and the UP
> > > boot seemed to stall after input: TPPS/2 message (but pressing
> > > ctrl-alt-delete allows the system to reboot cleanly).
> >
> > First let me thank you guys for looking into this issue. Looking at
> > your dmesg, it looked like storvsc probe failed as Dexuan had seen.
> > Since the failure appears to be alignment related, perhaps we could
> > test with allocating a page all the time (and getting rid of the
> > kmalloc). Sitsofe, here is a patch based on Dexuan's patch. If this
> > works, I will probably minimize failure cases by pre-allocating
> > per-cpu pages for this.:
> 
> After some modifications to apply on top of your previous patches applying
> this latest patch has cured the issues surrounding hyperv_fb issues on boot.
> The only issue seen on boot now is similar to
> https://lkml.org/lkml/2014/8/19/227 ...

That is good to hear. I was under the impression that this issue would be
resolved with all the cleanup we have done. The last patch-set I posted
earlier today has the fix for vmbus_open  bug that Dexuan had identified.

If you could try with the BUG_ON elimination patch-set I sent out earlier
today with the fix in hv.c that I had sent that would be great.  
> 
> How come previous alignment efforts weren't working out?
I have chosen to always allocate a page and so alignment won't be
an issue. I want to eliminate failure in this path and so, I will most likely
do a per-cpu pre-allocation of this buffer.

Thank you very much for taking the time to help us debug these issues.

Regards,

K. Y
> 
> --
> Sitsofe | http://sucs.org/~sits/
