Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbaKZB6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 20:58:30 -0500
Received: from mail-bn1on0137.outbound.protection.outlook.com ([157.56.110.137]:17440
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750938AbaKZB62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 20:58:28 -0500
Message-ID: <1416967101.15957.174.camel@freescale.com>
Subject: Re: [v4,17/21] powerpc/8xx: set PTE bit 22 off TLBmiss
From: Scott Wood <scottwood@freescale.com>
To: christophe leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 25 Nov 2014 19:58:21 -0600
In-Reply-To: <546BA6F3.2070106@c-s.fr>
References: <20140919083609.A92871AB040@localhost.localdomain>
	 <20141107033745.GA23796@home.buserror.net> <545C7C2E.3060109@c-s.fr>
	 <1415405305.3805.45.camel@snotra.buserror.net> <546BA6F3.2070106@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BN1PR08CA0033.namprd08.prod.outlook.com (10.242.217.161) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 04073E895A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(479174003)(199003)(377424004)(24454002)(189002)(50226001)(97736003)(4396001)(87286001)(89996001)(101416001)(88136002)(31966008)(23676002)(50466002)(92726001)(93916002)(122386002)(92566001)(86362001)(120916001)(99396003)(50986999)(76176999)(102836001)(104166001)(103116003)(95666004)(105586002)(64706001)(93886004)(20776003)(21056001)(62966003)(77096003)(77156002)(47776003)(36756003)(87976001)(46102003)(33646002)(106356001)(40100003)(107046002)(110136001)(42186005)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 21:07 +0100, christophe leroy wrote:
> Le 08/11/2014 01:08, Scott Wood a écrit :
> >
> > OK, so the _PAGE_KERNEL_RO(X) stuff is because initially setting the PTE
> > doesn't go through pte_update().
> >
> > I'll apply this, though it'd be cleaner to just have 8xx versions of the
> > relevant PTE accessor functions to maintain the PTE the way the hardware
> > wants (this would also eliminate the _PAGE_RW inversion that's still in
> > the TLB miss handler).
> >
> >
> 
> Yes, I've been looking at a simple way to also eliminate the _PAGE_RW 
> inversion, but i've not been able to find an easy solution up to now.
> 
> It seems that we have two functions that set PTE: set_pte_at() and 
> pte_update()
> I could perform the bit 22 (0x200) stuff and the _PAGE_RW invertion in 
> both functions, but then there are functions that read the PTE to make 
> decision based on PAGE_RW for instance.

Where?  The only relevant use of _PAGE_RW outside accessors that I see
is in gup_pte_range(), which shouldn't be too hard to fix up.

-Scott


