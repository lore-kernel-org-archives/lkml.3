Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965196AbaH1Dlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:41:46 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:41373
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932419AbaH1Dlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:41:45 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dexuan Cui <decui@microsoft.com>, Sitsofe Wheeler <sitsofe@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjYjJn6yhiZAUmfcA+tXSCe25vhYa6AgAA9PQCAARoEAIABlgcAgAANEQCAAAyZgIAAIPwAgAAi6gCAABhF8IAAVx2AgAABQrCAAEiYgIAABTig
Date: Thu, 28 Aug 2014 03:41:41 +0000
Message-ID: <fd356a5b3bba495ca84744c8b96a345a@BY2PR0301MB0711.namprd03.prod.outlook.com>
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
 <ec859d8c8f8743a0b72e5e578472f45d@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <EE124450C0AAF944A40DD71E61F878C9973DAC@SINEX14MBXC418.southpacific.corp.microsoft.com>
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C9973DAC@SINEX14MBXC418.southpacific.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 031763BCAF
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(164054003)(51704005)(199003)(377454003)(189002)(13464003)(86612001)(87936001)(1511001)(77982001)(21056001)(79102001)(81342001)(106356001)(33646002)(101416001)(106116001)(92566001)(105586002)(76176999)(85852003)(77096002)(81542001)(76482001)(15975445006)(74316001)(54356999)(50986999)(95666004)(83072002)(99286002)(99396002)(19580395003)(31966008)(108616004)(74502001)(74662001)(19580405001)(93886004)(4396001)(66066001)(2421001)(83322001)(76576001)(85306004)(80022001)(2656002)(90102001)(46102001)(86362001)(64706001)(20776003)(107046002)(7059011)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui
> Sent: Wednesday, August 27, 2014 8:22 PM
> To: KY Srinivasan; Sitsofe Wheeler
> Cc: Greg Kroah-Hartman; Haiyang Zhang; devel@linuxdriverproject.org;
> linux-kernel@vger.kernel.org
> Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
> ffff880077800004 (hv_ringbuffer_write)
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of KY Srinivasan
> > Sent: Thursday, August 28, 2014 7:14 AM
> > > > > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > > > > Sent: Wednesday, August 27, 2014 9:19 AM
> > > > >
> > > > > > BTW, with the patch below, hyperv_fb can work now, BUT,
> > > > > > *occasionally*,
> > > > > > storvsc_probe() -> ... -> vmbus_open() -> can fail due to
> > > > > > HV_STATUS_INVALID_ALIGNMENT...
> > > > >
> > > > > I applied your new patch on top of KY's pieces (it applied
> > > > > cleanly) and while it doesn't blow up, one warning is printed
> > > > > out and the UP boot seemed to stall after input: TPPS/2 message
> > > > > (but pressing ctrl-alt-delete allows the system to reboot cleanly).
> > > >
> > > > First let me thank you guys for looking into this issue. Looking
> > > > at your dmesg, it looked like storvsc probe failed as Dexuan had seen.
> > > > Since the failure appears to be alignment related, perhaps we
> > > > could test with allocating a page all the time (and getting rid of
> > > > the kmalloc). Sitsofe, here is a patch based on Dexuan's patch. If
> > > > this works, I will probably minimize failure cases by
> > > > pre-allocating per-cpu pages for this.:
> > >
> > > After some modifications to apply on top of your previous patches
> > applying
> > > this latest patch has cured the issues surrounding hyperv_fb issues
> > > on
> > boot.
> 
> This always-use-page-allocation patch of KY works for me too. :-)
> 
> 
> > > The only issue seen on boot now is similar to
> > > https://lkml.org/lkml/2014/8/19/227 ...
> Hi Sitsofe,
> I don't see this issue.
> Do you still see the issue for EVERY boot after you applied KY's always-use-
> page-allocation patch?
> I doubt that because in the log of the above link:
> 
> [   34.628072] hv_netvsc vmbus_0_15: net device safe to remove
> [   34.676573] hv_netvsc: hv_netvsc channel opened successfully
> [   34.860292] hv_netvsc vmbus_0_15 eth1: unable to establish send buffer's
> gpadl
> [   34.948983] hv_netvsc vmbus_0_15 eth1: unable to connect to NetVSP - 4
> 
> Here the 4 is just HV_STATUS_INVALID_ALIGNMENT -- it should be fixed by
> the patch.
> 
> >
> > That is good to hear. I was under the impression that this issue would
> > be resolved with all the cleanup we have done. The last patch-set I
> > posted earlier today has the fix for vmbus_open  bug that Dexuan had
> identified.
> >
> > If you could try with the BUG_ON elimination patch-set I sent out
> > earlier today with the fix in hv.c that I had sent that would be great.
> > >
> > > How come previous alignment efforts weren't working out?
> I'm not sure.
> If we trust the hypervisor, I would guess in hv_post_message()
> 1) We'd better add "aligned_msg->reserved = 0;"
> 2) Should we make sure  "aligned_msg->payload_size % 8 == 0"? IMO
>    aligned_msg->payload is an array of 8-byte.
> 
> > I have chosen to always allocate a page and so alignment won't be an
> > issue. I want to eliminate failure in this path and so, I will most
> > likely do a per-cpu pre-allocation of this buffer.
> This is a good idea!

Thank you all. I will submit a patch with the pre-allocated per-cpu page for this.

K. Y
> 
> Thanks,
> -- Dexuan

