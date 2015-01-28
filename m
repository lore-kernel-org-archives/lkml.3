Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888AbbA1UTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:19:45 -0500
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:65525
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932756AbbA1UTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:19:41 -0500
Date: Wed, 28 Jan 2015 14:14:17 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Andrew Morton <akpm@linux-foundation.org>, Joonsoo Kim <js1304@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rik van Riel <riel@redhat.com>,
        "Linux Memory Management List" <linux-mm@kvack.org>,
        <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>, Minchan Kim <minchan@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v3] powerpc/mm: fix undefined reference to
 `.__kernel_map_pages' on FSL PPC64
Message-ID: <20150128141417.ba2e413fd8ccc8bfd65196e1@freescale.com>
In-Reply-To: <1422415322.32234.3.camel@ellerman.id.au>
References: <20150120140200.aa7ba0eb28d95e456972e178@freescale.com>
	<20150120230150.GA14475@cloud>
	<20150120160738.edfe64806cc8b943beb1dfa0@linux-foundation.org>
	<CAC5umyieZn7ppXkKb45O=C=BF+iv6R_A1Dwfhro=cBJzFeovrA@mail.gmail.com>
	<20150122014550.GA21444@js1304-P5Q-DELUXE>
	<20150122144147.019eedc41f189eac44c3c4cd@freescale.com>
	<CAC5umyiF52cykH2_5TD0yzXb+842gywpe-+XZHEwmrDe0nYCPw@mail.gmail.com>
	<20150122212017.4b7032d52a6c75c06d5b4728@freescale.com>
	<1421987091.24984.13.camel@ellerman.id.au>
	<20150126132222.6477257be204a3332601ef11@freescale.com>
	<1422406862.32234.1.camel@ellerman.id.au>
	<CAAmzW4M3O81wBFeZ+JEVZnjRwMNwXnPKeL62Zz96xe_6a7WZpg@mail.gmail.com>
	<20150127185711.ee819e4b.akpm@linux-foundation.org>
	<1422415322.32234.3.camel@ellerman.id.au>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=kim.phillips@freescale.com; freescale.mail.onmicrosoft.com;
 dkim=none (message not signed) header.d=none;freescale.mail.onmicrosoft.com;
 dmarc=permerror action=none header.from=freescale.com;
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(377424004)(24454002)(19580395003)(19580405001)(77096005)(92566002)(6806004)(93886004)(86362001)(23726002)(50466002)(50986999)(76176999)(104016003)(46406003)(33646002)(2950100001)(100306002)(106466001)(36756003)(85426001)(47776003)(105606002)(62966003)(87936001)(77156002)(50226001)(46102003)(110136001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0727;H:az84smr01.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0727;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0727;
X-Forefront-PRVS: 047001DADA
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0727;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2015 20:19:36.7478
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.158.2]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0727
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2015 14:22:02 +1100
Michael Ellerman <mpe@ellerman.id.au> wrote:

> On Tue, 2015-01-27 at 18:57 -0800, Andrew Morton wrote:
> > On Wed, 28 Jan 2015 10:33:59 +0900 Joonsoo Kim <js1304@gmail.com> wrote:
> > 
> > > 2015-01-28 10:01 GMT+09:00 Michael Ellerman <mpe@ellerman.id.au>:
> > > > On Mon, 2015-01-26 at 13:22 -0600, Kim Phillips wrote:
> > > >> arch/powerpc has __kernel_map_pages implementations in mm/pgtable_32.c, and
> > > >
> > > > I'd be happy to take this through the powerpc tree for 3.20, but for this:
> > > >
> > > >> depends on:
> > > >> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > > >> Date: Thu, 22 Jan 2015 10:28:58 +0900
> > > >> Subject: [PATCH] mm/debug_pagealloc: fix build failure on ppc and some other archs
> > > >
> > > > I don't have that patch in my tree.
> > > >
> > > > But in what way does this patch depend on that one?
> > > >
> > > > It looks to me like it'd be safe to take this on its own, or am I wrong?
> > > 
> > > Hello,
> > > 
> > > These two patches are merged to Andrew's tree now.
> > 
> > That didn't answer either of Michael's questions ;)
> > 
> > Yes, I think they're independent.  I was holding off on the powerpc

sorry - my bad, they are indeed completely independent.

> > one, waiting to see if it popped up in linux-next via your tree.  I can
> > merge both if you like?
> 
> Right, I didn't think I'd seen it in your tree :)
> 
> I'm happy to take this one, saves a possible merge conflict.

I'm fine either way (I work on linux-next).

Kim
