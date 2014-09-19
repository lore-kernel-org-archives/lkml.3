Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbaISUWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:22:32 -0400
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:46688
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757861AbaISUWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:22:31 -0400
Message-ID: <1411157986.13320.75.camel@snotra.buserror.net>
Subject: Re: [PATCH 03/15] powerpc/msi: Improve IRQ bitmap allocator
From: Scott Wood <scottwood@freescale.com>
To: Michael Neuling <mikey@neuling.org>
CC: <greg@kroah.com>, <arnd@arndb.de>, <mpe@ellerman.id.au>,
        <benh@kernel.crashing.org>, <cbe-oss-dev@lists.ozlabs.org>,
        <imunsie@au.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@ozlabs.org>, <jk@ozlabs.org>, <anton@samba.org>,
        "Laurentiu Tudor" <Laurentiu.Tudor@freescale.com>
Date: Fri, 19 Sep 2014 15:19:46 -0500
In-Reply-To: <1411157769.13320.74.camel@snotra.buserror.net>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-4-git-send-email-mikey@neuling.org>
	 <1411157769.13320.74.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:2d6a:b3e0:e03e:359e]
X-ClientProxiedBy: BL2PR08CA0051.namprd08.prod.outlook.com (10.255.170.169) To
 BN1PR0301MB0722.namprd03.prod.outlook.com (25.160.78.141)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0722;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377424004)(199003)(51704005)(24454002)(189002)(97736003)(104166001)(93916002)(87976001)(15202345003)(105586002)(77156001)(77096002)(101416001)(88136002)(77982003)(81342003)(86362001)(33646002)(95666004)(74662003)(81542003)(107046002)(31966008)(85852003)(19580395003)(76176999)(15975445006)(20776003)(83072002)(85306004)(47776003)(50986999)(64706001)(79102003)(4396001)(50226001)(80022003)(90102001)(21056001)(102836001)(19580405001)(74502003)(42186005)(99396002)(46102003)(110136001)(50466002)(106356001)(62966002)(23676002)(92566001)(83322001)(76482002)(103116003)(89996001)(87286001)(92726001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0722;H:[IPv6:2601:2:5800:3f7:2d6a:b3e0:e03e:359e];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-19 at 15:16 -0500, Scott Wood wrote:
> On Thu, 2014-09-18 at 18:26 +1000, Michael Neuling wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > Currently msi_bitmap_alloc_hwirqs() will round up any IRQ allocation requests
> > to the nearest power of 2.  eg. ask for 5 IRQs and you'll get 8.  This wastes a
> > lot of IRQs which can be a scarce resource.
> > 
> > For cxl we can require multiple IRQs for every contexts that is attached to the
> > accelerator.  For AFU directed accelerators, there may be 1000s of contexts
> > attached, hence we can easily run out of IRQs, especially if we are needlessly
> > wasting them.
> > 
> > This changes the msi_bitmap_alloc_hwirqs() to allocate only the required number
> > of IRQs, hence avoiding this wastage.
> > 
> > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > ---
> >  arch/powerpc/sysdev/msi_bitmap.c | 18 +++++++++++++-----
> >  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> This conflicts with (and partially duplicates)
> http://patchwork.ozlabs.org/patch/381892/
> which I have in my tree.  How should we handle it?
> 
> Laurentiu, from looking at the overlap between patches I see a problem
> with your existing patch, regarding the out-of-irqs path and
> msi_bitmap_free_hwirqs(), so one way or another that needs to get fixed
> soon.

Given the problems with Laurentiu's patch, perhaps it'd be best for me
to just revert that patch in my tree, and respin it after this patchset
has been merged.

-Scott


