Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaHTLQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:16:26 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:16650
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751975AbaHTLQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:16:22 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Kylie Liang <kyliel@microsoft.com>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPvFjgvav2zR0lYke3SB9WxJlS05vZVRgg
Date: Wed, 20 Aug 2014 11:15:39 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C993BD4E@SINEX14MBXC417.southpacific.corp.microsoft.com>
References: <20140820092630.GA1478@sucs.org>
In-Reply-To: <20140820092630.GA1478@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.92]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(164054003)(377454003)(199003)(52604005)(13464003)(189002)(51704005)(46406003)(74662001)(21056001)(84676001)(55846006)(95666004)(74502001)(31966008)(76176999)(20776003)(6806004)(44976005)(87936001)(77096002)(46102001)(69596002)(85806002)(106116001)(110136001)(97756001)(68736004)(80022001)(16796002)(4396001)(76482001)(97736001)(107046002)(92566001)(83072002)(19580405001)(92726001)(77982001)(85306004)(85852003)(23726002)(86362001)(79102001)(99396002)(81542001)(50466002)(33656002)(86612001)(54356999)(81342001)(26826002)(2656002)(83322001)(64706001)(47776003)(81156004)(50986999)(19580395003)(106466001)(1411001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB256;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03094A4065
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Sitsofe Wheeler
> Sent: Wednesday, August 20, 2014 17:27 PM
> To: Dexuan Cui
> Cc: KY Srinivasan; Greg Kroah-Hartman; Haiyang Zhang;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Jean-Christophe
> Plagniol-Villard; linux-fbdev@vger.kernel.org
> 
> While booting a Hyper-V 3.17.0-rc1 guest on a 2012 R2 host a BUG was
> triggered while registering hyperv_fb which in turn caused a panic.
> Various kernel debugging options (CONFIG_DEBUG_PAGEALLOC,
> CONFIG_SLUB_DEBUG=y...) were on at the time. This only seems to happen
> if the guest is being booted with only one CPU allocated to it.
> 
> [    7.645526] hv_vmbus: registering driver hyperv_fb
> [    7.657553] BUG: unable to handle kernel paging request at
> ffff880077800004
> [    7.658224] IP: [<ffffffff8159a7ac>] hv_ringbuffer_write+0x7c/0x150
> [    7.658224] PGD 2da9067 PUD 2dac067 PMD 7fa27067 PTE
> 8000000077800060
> [    7.658224] Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Hi Sitsofe,
Thanks for reporting the issue!
I suppose you're using  the latest mainline v3.17-rc1(7d1311b9).

Can you please attach your kernel config file so that I can try to reproduce
the issue more easily?

Do you mean the issue only happens to UP guest and doesn't happen to
SMP guest?

Thanks,
-- Dexuan
