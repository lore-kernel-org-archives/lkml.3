Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaH0Hv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:51:58 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:59796
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751085AbaH0Hv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:51:56 -0400
From: Dexuan Cui <decui@microsoft.com>
To: Jan Beulich <JBeulich@suse.com>
CC: "jeremy@goop.org" <jeremy@goop.org>, KY Srinivasan <kys@microsoft.com>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: sync_set_bit() vs set_bit()  -- what's the difference?
Thread-Topic: sync_set_bit() vs set_bit()  -- what's the difference?
Thread-Index: Ac/BxOSGReNLYy7sSGa/c8GpUfDFQgABQP2AAABaMBA=
Date: Wed, 27 Aug 2014 07:50:52 +0000
Message-ID: <EE124450C0AAF944A40DD71E61F878C9963AA0@SINEX14MBXC419.southpacific.corp.microsoft.com>
References: <EE124450C0AAF944A40DD71E61F878C99639F3@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <53FDA71B020000780002DF2E@mail.emea.novell.com>
In-Reply-To: <53FDA71B020000780002DF2E@mail.emea.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(377454003)(189002)(13464003)(24454002)(164054003)(51704005)(74502001)(50466002)(23726002)(90102001)(97736001)(16796002)(110136001)(99396002)(31966008)(74662001)(97756001)(68736004)(83322001)(44976005)(6806004)(19580395003)(107046002)(4396001)(47776003)(20776003)(84676001)(80022001)(2656002)(86362001)(64706001)(54356999)(19580405001)(69596002)(85306004)(92726001)(26826002)(92566001)(81342001)(106466001)(81156004)(87936001)(33656002)(81542001)(77982001)(46102001)(55846006)(46406003)(21056001)(86612001)(77096002)(95666004)(79102001)(85852003)(83072002)(76176999)(76482001)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB256;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0316567485
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jan Beulich
> Sent: Wednesday, August 27, 2014 15:39 PM
> >>> On 27.08.14 at 09:30, <decui@microsoft.com> wrote:
> > I'm curious about the difference. :-)
> >
> > sync_set_bit() is only used in drivers/hv/ and drivers/xen/ while set_bit()
> > is used in all other places. What makes hv/xen special?
> 
> I guess this would really want to be used by anything communicating
> with a hypervisor or a remote driver: set_bit() gets its LOCK prefix
> discarded when the local kernel determines it runs on a single CPU
> only. Obviously having knowledge of the CPU count inside a VM does
> not imply anything about the number of CPUs available to the host,
> i.e. stripping LOCK prefixes in that case would be unsafe.
> 
> Jan

Thank you, Juergen and Jan for your  quick answers!

I didn't realize LOCK_PREFIX is "" for UP. :-)

Thanks,
-- Dexuan
