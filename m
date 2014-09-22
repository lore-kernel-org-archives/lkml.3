Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaIVXu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:50:59 -0400
Received: from mail-by2on0119.outbound.protection.outlook.com ([207.46.100.119]:6910
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753643AbaIVXu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:50:57 -0400
Message-ID: <1411429840.13320.100.camel@snotra.buserror.net>
Subject: Re: [PATCH 03/15] powerpc/msi: Improve IRQ bitmap allocator
From: Scott Wood <scottwood@freescale.com>
To: Laurentiu Tudor <b10716@freescale.com>
CC: Michael Neuling <mikey@neuling.org>, <greg@kroah.com>, <arnd@arndb.de>,
        <mpe@ellerman.id.au>, <benh@kernel.crashing.org>,
        <cbe-oss-dev@lists.ozlabs.org>, <imunsie@au.ibm.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
        <jk@ozlabs.org>, <anton@samba.org>,
        Laurentiu Tudor <Laurentiu.Tudor@freescale.com>
Date: Mon, 22 Sep 2014 18:50:40 -0500
In-Reply-To: <541FDD32.8020105@freescale.com>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
		 <1411028820-29933-4-git-send-email-mikey@neuling.org>
		 <1411157769.13320.74.camel@snotra.buserror.net>
	 <1411157986.13320.75.camel@snotra.buserror.net>
	 <541FDD32.8020105@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:2cb0:f9c5:c80d:2765]
X-ClientProxiedBy: BN1PR02CA0022.namprd02.prod.outlook.com (10.141.56.22) To
 BY2PR0301MB0727.namprd03.prod.outlook.com (25.160.63.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0727;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(189002)(479174003)(199003)(377424004)(51704005)(24454002)(23676002)(93916002)(74502003)(81542003)(19580405001)(79102003)(92726001)(50986999)(83322001)(80022003)(88136002)(87976001)(77096002)(87286001)(89996001)(50226001)(92566001)(104166001)(10300001)(19580395003)(81342003)(76176999)(4396001)(74662003)(99396002)(86362001)(103116003)(102836001)(62966002)(15975445006)(95666004)(50466002)(101416001)(106356001)(90102001)(110136001)(21056001)(105586002)(42186005)(93886004)(85852003)(77982003)(83072002)(20776003)(76482002)(107046002)(31966008)(47776003)(77156001)(120916001)(97736003)(46102003)(33646002)(64706001)(85306004)(15202345003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0727;H:[IPv6:2601:2:5800:3f7:2cb0:f9c5:c80d:2765];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-22 at 11:26 +0300, Laurentiu Tudor wrote:
> On 09/19/2014 11:19 PM, Scott Wood wrote:
> > On Fri, 2014-09-19 at 15:16 -0500, Scott Wood wrote:
> >> On Thu, 2014-09-18 at 18:26 +1000, Michael Neuling wrote:
> >>> From: Ian Munsie <imunsie@au1.ibm.com>
> >>>
> >>> Currently msi_bitmap_alloc_hwirqs() will round up any IRQ allocation requests
> >>> to the nearest power of 2.  eg. ask for 5 IRQs and you'll get 8.  This wastes a
> >>> lot of IRQs which can be a scarce resource.
> >>>
> >>> For cxl we can require multiple IRQs for every contexts that is attached to the
> >>> accelerator.  For AFU directed accelerators, there may be 1000s of contexts
> >>> attached, hence we can easily run out of IRQs, especially if we are needlessly
> >>> wasting them.
> >>>
> >>> This changes the msi_bitmap_alloc_hwirqs() to allocate only the required number
> >>> of IRQs, hence avoiding this wastage.
> >>>
> >>> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> >>> Signed-off-by: Michael Neuling <mikey@neuling.org>
> >>> ---
> >>>  arch/powerpc/sysdev/msi_bitmap.c | 18 +++++++++++++-----
> >>>  1 file changed, 13 insertions(+), 5 deletions(-)
> >>
> >> This conflicts with (and partially duplicates)
> >> http://patchwork.ozlabs.org/patch/381892/
> >> which I have in my tree.  How should we handle it?
> >>
> >> Laurentiu, from looking at the overlap between patches I see a problem
> >> with your existing patch, regarding the out-of-irqs path and
> >> msi_bitmap_free_hwirqs(), so one way or another that needs to get fixed
> >> soon.
> > 
> > Given the problems with Laurentiu's patch, perhaps it'd be best for me
> > to just revert that patch in my tree, and respin it after this patchset
> > has been merged.
> 
> Let me know if you want me to rebase my stuff on top of Michael's patch.

Yes, please resend it once Michael's patch gets merged.

-Scott


