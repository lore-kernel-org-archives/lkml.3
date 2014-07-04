Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaGDMru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:47:50 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:5836
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751299AbaGDMrs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:47:48 -0400
From: Varun Sethi <Varun.Sethi@freescale.com>
To: Joerg Roedel <joro@8bytes.org>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
Subject: RE: [PATCH 1/3] iommu/fsl: Fix PAMU window size check.
Thread-Topic: [PATCH 1/3] iommu/fsl: Fix PAMU window size check.
Thread-Index: AQHPl3Tx2js/Q4m20U+G0WdkjjU3dpuP3F4A
Date: Fri, 4 Jul 2014 12:47:44 +0000
Message-ID: <6425d2420c6f4f03b15f2d7ce5be3215@BL2PR03MB468.namprd03.prod.outlook.com>
References: <1403618237-26248-1-git-send-email-Varun.Sethi@freescale.com>
 <1403618237-26248-2-git-send-email-Varun.Sethi@freescale.com>
 <20140704104430.GD13434@8bytes.org>
In-Reply-To: <20140704104430.GD13434@8bytes.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(377454003)(189002)(199002)(51704005)(13464003)(76482001)(2656002)(81542001)(81342001)(19580395003)(87936001)(101416001)(19580405001)(106356001)(21056001)(83322001)(76576001)(106116001)(20776003)(74316001)(86362001)(54356999)(99396002)(85852003)(85306003)(46102001)(31966008)(79102001)(64706001)(76176999)(99286002)(74662001)(83072002)(50986999)(105586002)(80022001)(33646001)(95666004)(4396001)(74502001)(92566001)(66066001)(110136001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB468.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Joerg Roedel [mailto:joro@8bytes.org]
> Sent: Friday, July 04, 2014 4:15 PM
> To: Sethi Varun-B16395
> Cc: iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> linuxppc-dev@lists.ozlabs.org; alex.williamson@redhat.com
> Subject: Re: [PATCH 1/3] iommu/fsl: Fix PAMU window size check.
> 
> On Tue, Jun 24, 2014 at 07:27:15PM +0530, Varun Sethi wrote:
> >  	/* window size is 2^(WSE+1) bytes */
> > -	return __ffs(addrspace_size) - 1;
> > +	return fls64(addrspace_size) - 2;
> 
> This looks bogus, why do you replace ffs (find-first-bit) by fls (find-
> last-bit)?
> 
Address space size is always a power of 2. This change was required to handle address sizes > 32bit width on 32 bit architectures.

-Varun

