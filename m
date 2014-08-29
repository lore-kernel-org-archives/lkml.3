Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaH2Dk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 23:40:57 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:42595
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750983AbaH2Dk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 23:40:56 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPwr6FHOqdouoVV0yV/yTpMU6fvpvm2tqw
Date: Fri, 29 Aug 2014 03:39:40 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9977892@SINEX14MBXC418.southpacific.corp.microsoft.com>
References: <EE124450C0AAF944A40DD71E61F878C995E93E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827104408.GC1827@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C996493E@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827121559.GA14286@sucs.org>
 <EE124450C0AAF944A40DD71E61F878C9965238@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <20140827161900.GA25326@sucs.org>
 <51ae44fcae424365a6d78f3597175d77@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140827225739.GA24590@sucs.org>
 <ec859d8c8f8743a0b72e5e578472f45d@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <EE124450C0AAF944A40DD71E61F878C9973DAC@SINEX14MBXC418.southpacific.corp.microsoft.com>
 <20140828124846.GA20494@sucs.org>
In-Reply-To: <20140828124846.GA20494@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.98]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377454003)(199003)(13464003)(51704005)(189002)(164054003)(1411001)(97756001)(81542001)(46102001)(77982001)(46406003)(4396001)(81342001)(90102001)(26826002)(93886004)(33656002)(76482001)(106116001)(85852003)(97736001)(74502001)(92726001)(92566001)(21056001)(50466002)(106466001)(77096002)(74662001)(31966008)(79102001)(23726002)(110136001)(15975445006)(20776003)(76176999)(44976005)(47776003)(69596002)(50986999)(81156004)(83072002)(99396002)(95666004)(107046002)(86362001)(6806004)(86612001)(83322001)(85306004)(16796002)(84676001)(19580395003)(68736004)(87936001)(80022001)(64706001)(2656002)(54356999)(55846006);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB252;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0318501FAE
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler
> Sent: Thursday, August 28, 2014 20:49 PM
> > > > The only issue seen on boot now is similar to
> > > > https://lkml.org/lkml/2014/8/19/227 ...
> 
> > I don't see this issue.  Do you still see the issue for EVERY boot
> > after you applied KY's always-use-page-allocation patch?  I doubt that
> > because in the log of the above link:
> 
> I think it depends on if I do a UP or SMP boot. With
> f1bd473f95e02bc382d4dae94d7f82e2a455e05d (post v3.17-rc2) with the V2
> BUG_ON
> patch set coupled with the allocation change patch set a UP boot was able
> to
> run a small bunch of CPU and network stress tests without any issue.
> However,
> when doing an SMP boot the following happened:
>  <snip>
> We can spin these off into a different thread if that would be helpful.

Hi Sitsofe,
This seems a hv_netvsc specific issue(?)
IMO it's better to open a new thread. 

However, I tried vcpus=1, 2 and 4 for 5 times respectively but couldn't
reproduce the same issue(surely I used all of KY's patches, including the
page-aligned-input-parameter-for-hypercall one)
I used a workload of dd-ing and scp-ing big files.

> > > > How come previous alignment efforts weren't working out?
> > I'm not sure.
> > If we trust the hypervisor, I would guess in hv_post_message()
> > 1) We'd better add "aligned_msg->reserved = 0;"
> > 2) Should we make sure  "aligned_msg->payload_size % 8 == 0"? IMO
> >    aligned_msg->payload is an array of 8-byte.
> 
> In that case why would payload_size not be a multiple of 8 - can it
> change due to debug padding? If so wouldn't its start have had to be
> misaligned?

I found in some normal code path, e.g.,
vmbus_open() -> vmbus_post_msg() -> ...
(here the payload size is sizeof(struct vmbus_channel_open_channel),
i.e., 148, not a multiple of 8), the payload_size is not a multiple of 8.
I don't think this causes the issue here, but I think we'd better double
check this and see if there is a potential issue or not.

Thanks,
-- Dexuan
