Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934703AbaH0N4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:56:31 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:57989
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933404AbaH0N4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:56:30 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jan Beulich <JBeulich@suse.com>, Dexuan Cui <decui@microsoft.com>
CC: "jeremy@goop.org" <jeremy@goop.org>,
        "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: sync_set_bit() vs set_bit()  -- what's the difference?
Thread-Topic: sync_set_bit() vs set_bit()  -- what's the difference?
Thread-Index: Ac/BxOSGReNLYy7sSGa/c8GpUfDFQgABQP2AAA0qKzA=
Date: Wed, 27 Aug 2014 13:56:27 +0000
Message-ID: <032994b8585e483c86e71402ecd5a163@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <EE124450C0AAF944A40DD71E61F878C99639F3@SINEX14MBXC419.southpacific.corp.microsoft.com>
 <53FDA71B020000780002DF2E@mail.emea.novell.com>
In-Reply-To: <53FDA71B020000780002DF2E@mail.emea.novell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(199003)(189002)(377454003)(24454002)(51704005)(99396002)(101416001)(21056001)(19580395003)(83322001)(19580405001)(81342001)(76576001)(2421001)(87936001)(85852003)(83072002)(74316001)(106356001)(33646002)(86362001)(64706001)(105586002)(92566001)(20776003)(31966008)(74662001)(74502001)(76482001)(66066001)(85306004)(108616004)(90102001)(77982001)(50986999)(107046002)(1511001)(95666004)(76176999)(79102001)(46102001)(4396001)(2656002)(80022001)(77096002)(54356999)(81542001)(7059011)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Wednesday, August 27, 2014 12:39 AM
> To: Dexuan Cui
> Cc: jeremy@goop.org; KY Srinivasan; chrisw@sous-sol.org; linux-
> kernel@vger.kernel.org
> Subject: Re: sync_set_bit() vs set_bit() -- what's the difference?
> 
> >>> On 27.08.14 at 09:30, <decui@microsoft.com> wrote:
> > I'm curious about the difference. :-)
> >
> > sync_set_bit() is only used in drivers/hv/ and drivers/xen/ while
> > set_bit() is used in all other places. What makes hv/xen special?
> 
> I guess this would really want to be used by anything communicating with a
> hypervisor or a remote driver: set_bit() gets its LOCK prefix discarded when
> the local kernel determines it runs on a single CPU only. Obviously having
> knowledge of the CPU count inside a VM does not imply anything about the
> number of CPUs available to the host, i.e. stripping LOCK prefixes in that case
> would be unsafe.

That is exactly the case for Hyper-V (and Xen).

K. Y

