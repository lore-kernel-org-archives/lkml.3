Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936226AbaH1DWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:22:31 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:32891
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751086AbaH1DWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:22:30 -0400
From: Dexuan Cui <decui@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>, Sitsofe Wheeler <sitsofe@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjgvav2zR0lYke3SB9WxJlS05vhXWzggABBfwCAAQnBQIABpkoAgAAIh7CAABEjgIAAHqJwgAAlRACAACkMgIAARlWAgAAEgoCAADwU8A==
Date: Thu, 28 Aug 2014 03:21:59 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9973DAC@SINEX14MBXC418.southpacific.corp.microsoft.com>
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
In-Reply-To: <ec859d8c8f8743a0b72e5e578472f45d@BY2PR0301MB0711.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.83]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(377454003)(199003)(13464003)(164054003)(51704005)(86612001)(92566001)(21056001)(92726001)(79102001)(97736001)(76482001)(1511001)(50466002)(106116001)(77096002)(54356999)(77982001)(50986999)(87936001)(26826002)(80022001)(85852003)(81542001)(74662001)(83072002)(55846006)(95666004)(46406003)(107046002)(106466001)(76176999)(74502001)(15975445006)(85306004)(19580405001)(81342001)(69596002)(19580395003)(44976005)(6806004)(68736004)(23726002)(83322001)(64706001)(93886004)(99396002)(33656002)(90102001)(84676001)(31966008)(47776003)(86362001)(46102001)(16796002)(2656002)(2421001)(97756001)(4396001)(20776003)(81156004);DIR:OUT;SFP:;SCL:1;SRVR:CH1PR03MB622;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 031763BCAF
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of KY Srinivasan
> Sent: Thursday, August 28, 2014 7:14 AM
> > > > From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> > > > Sent: Wednesday, August 27, 2014 9:19 AM
> > > >
> > > > > BTW, with the patch below, hyperv_fb can work now, BUT,
> > > > > *occasionally*,
> > > > > storvsc_probe() -> ... -> vmbus_open() -> can fail due to
> > > > > HV_STATUS_INVALID_ALIGNMENT...
> > > >
> > > > I applied your new patch on top of KY's pieces (it applied cleanly)
> > > > and while it doesn't blow up, one warning is printed out and the UP
> > > > boot seemed to stall after input: TPPS/2 message (but pressing
> > > > ctrl-alt-delete allows the system to reboot cleanly).
> > >
> > > First let me thank you guys for looking into this issue. Looking at
> > > your dmesg, it looked like storvsc probe failed as Dexuan had seen.
> > > Since the failure appears to be alignment related, perhaps we could
> > > test with allocating a page all the time (and getting rid of the
> > > kmalloc). Sitsofe, here is a patch based on Dexuan's patch. If this
> > > works, I will probably minimize failure cases by pre-allocating
> > > per-cpu pages for this.:
> >
> > After some modifications to apply on top of your previous patches
> applying
> > this latest patch has cured the issues surrounding hyperv_fb issues on
> boot.

This always-use-page-allocation patch of KY works for me too. :-)


> > The only issue seen on boot now is similar to
> > https://lkml.org/lkml/2014/8/19/227 ...
Hi Sitsofe,
I don't see this issue.
Do you still see the issue for EVERY boot after you applied KY's
always-use-page-allocation patch?
I doubt that because in the log of the above link:

[   34.628072] hv_netvsc vmbus_0_15: net device safe to remove
[   34.676573] hv_netvsc: hv_netvsc channel opened successfully
[   34.860292] hv_netvsc vmbus_0_15 eth1: unable to establish send buffer's gpadl
[   34.948983] hv_netvsc vmbus_0_15 eth1: unable to connect to NetVSP - 4

Here the 4 is just HV_STATUS_INVALID_ALIGNMENT -- it should be fixed
by the patch.

> 
> That is good to hear. I was under the impression that this issue would be
> resolved with all the cleanup we have done. The last patch-set I posted
> earlier today has the fix for vmbus_open  bug that Dexuan had identified.
> 
> If you could try with the BUG_ON elimination patch-set I sent out earlier
> today with the fix in hv.c that I had sent that would be great.
> >
> > How come previous alignment efforts weren't working out?
I'm not sure.
If we trust the hypervisor, I would guess in hv_post_message()
1) We'd better add "aligned_msg->reserved = 0;"
2) Should we make sure  "aligned_msg->payload_size % 8 == 0"? IMO
   aligned_msg->payload is an array of 8-byte.

> I have chosen to always allocate a page and so alignment won't be
> an issue. I want to eliminate failure in this path and so, I will most likely
> do a per-cpu pre-allocation of this buffer.
This is a good idea!

Thanks,
-- Dexuan
