Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaH2KRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:17:23 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:21337
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006AbaH2KRV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:17:21 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        KY Srinivasan <kys@microsoft.com>
CC: Sitsofe Wheeler <sitsofe@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: RE: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Topic: [PANIC, hyperv] BUG: unable to handle kernel paging request at
 ffff880077800004 (hv_ringbuffer_write)
Thread-Index: AQHPw26QHOqdouoVV0yV/yTpMU6fvpvnW6KA
Date: Fri, 29 Aug 2014 10:16:32 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C997956C@SINEX14MBXC418.southpacific.corp.microsoft.com>
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
 <20140829094945.GA5122@mwanda>
In-Reply-To: <20140829094945.GA5122@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.96]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(13464003)(199003)(51704005)(164054003)(377454003)(4396001)(33656002)(85306004)(93886004)(99396002)(50466002)(15202345003)(90102001)(21056001)(2421001)(86362001)(23726002)(76176999)(54356999)(80022001)(20776003)(50986999)(47776003)(86612001)(64706001)(97736001)(97756001)(46406003)(81342001)(2656002)(81542001)(69596002)(68736004)(6806004)(44976005)(83322001)(19580395003)(19580405001)(84676001)(15975445006)(77096002)(92566001)(92726001)(83072002)(85852003)(26826002)(74662001)(74502001)(31966008)(16796002)(87936001)(107046002)(106466001)(55846006)(46102001)(76482001)(81156004)(95666004)(79102001)(77982001)(1511001)(106116001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB618;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
> From: Dan Carpenter
> Sent: Friday, August 29, 2014 17:50 PM
> To: KY Srinivasan
> Cc: Sitsofe Wheeler; Dexuan Cui; Greg Kroah-Hartman; Haiyang Zhang;
> linux-kernel@vger.kernel.org; devel@linuxdriverproject.org
> Subject: Re: [PANIC, hyperv] BUG: unable to handle kernel paging request at
> ffff880077800004 (hv_ringbuffer_write)
> 
> It's sort of weird that this is an alignment issue.  The config that
> was posted earlier was an x86_64 config and on that system then the
> pointers from kmalloc() should already be aligned correctly at
> sizeof(u64).
> 
> Earlier I said I suspected the code is racy, so possibly changing from
> kmalloc() to get_zeroed_page() just changes the timing enough so we
> don't see the race condition.
> 
> regards,
> dan carpenter

Hi Dan,

Section 4.11.3 of Hypervisor Top Level Functional Specification(available at
http://blogs.msdn.com/b/virtual_pc_guy/archive/2014/02/17/updated-hypervisor-top-level-functional-specification.aspx)
says HV_STATUS_INVALID_ALIGNMENT can also be returned for a hypercall if
"the specified input or output parameter lists spans pages."

My understanding is: the input's memory range shouldn't cross a page
boundary.

Thanks,
-- Dexuan

