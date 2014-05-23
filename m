Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaEWRMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:12:36 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:57193
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752533AbaEWRMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:12:35 -0400
Message-ID: <1400865146.12823.54.camel@snotra.buserror.net>
Subject: Re: powerpc: remove checks for CONFIG_BOOK3E_MMU_TLB_STATS
From: Scott Wood <scottwood@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 23 May 2014 12:12:26 -0500
In-Reply-To: <1400839597.31526.21.camel@x220>
References: <1400608550.4912.48.camel@x220>
	 <20140522223758.GA20343@home.buserror.net> <1400830406.31526.6.camel@x220>
	 <1400839597.31526.21.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:d489:e54e:7b01:2a5f]
X-ClientProxiedBy: BLUPR09CA007.namprd09.prod.outlook.com (10.255.219.145)
 To DM2PR03MB398.namprd03.prod.outlook.com (10.141.84.140)
X-Forefront-PRVS: 0220D4B98D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(428001)(52604005)(377424004)(189002)(199002)(51704005)(77156001)(81542001)(20776003)(86362001)(83322001)(93916002)(31966008)(47776003)(50986999)(81342001)(62966002)(80022001)(50226001)(74502001)(87976001)(64706001)(92566001)(4396001)(99396002)(87286001)(74662001)(92726001)(79102001)(76176999)(21056001)(46102001)(77982001)(33646001)(88136002)(23676002)(42186004)(83072002)(103116003)(89996001)(50466002)(102836001)(85852003)(101416001)(76482001)(99106001)(3826001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB398;H:[IPv6:2601:2:5800:3f7:d489:e54e:7b01:2a5f];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 12:06 +0200, Paul Bolle wrote:
> On Fri, 2014-05-23 at 09:33 +0200, Paul Bolle wrote:
> > Scott,
> > 
> > On Thu, 2014-05-22 at 17:37 -0500, Scott Wood wrote:
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S: Assembler messages:
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:89: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:238: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:269: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:281: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:441: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:510: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:881: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:918: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > 
> > Thanks for testing!
> > 
> > That's a bit surprising. The patch is intended to be a non event. Ie, it
> > only removes what the preprocessor would have removed anyway. Unless I
> > botched it, of course.
> > 
> > What exactly did you test there?
> 
> For what it's worth: I can't reproduce this error with the cross
> compiler now shipped with Fedora 20 (ie, powerpc64-linux-gnu-gcc (GCC)
> 4.8.1 20130717 (Red Hat 4.8.1-5)). It shows a nice and clean
>      AS      arch/powerpc/mm/tlb_low_64e.o
> 
> in the output.
> 
> That's v3.15-rc6, with just this patch, and using a .config generated,
> with "make oldconfig", from arch/powerpc/configs/ppc64e_defconfig.

Hmm, I tried applying again and it was fine.  I guess I accidentally
removed one line too many when resolving a conflict with
b1576fec7f4dd4657694fefc97fda4cf28ec68e9 "powerpc: No need to use dot
symbols when branching to a function" that's in Ben's -next tree.

-Scott


