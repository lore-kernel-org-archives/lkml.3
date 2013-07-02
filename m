Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab3GBGVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:21:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49658 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab3GBGVq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:21:46 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Olof Johansson <olof@lixom.net>, Artem Bityutskiy <dedekind1@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        "Tony Lindgren" <tony@atomide.com>
Subject: RE: linux-next: manual merge of the arm-soc tree with the l2-mtd
 tree
Thread-Topic: linux-next: manual merge of the arm-soc tree with the l2-mtd
 tree
Thread-Index: AQHOduU2dcpaTOKd5UeUjh6prs+vjZlQ3XWQ//+BngCAAIfrYA==
Date: Tue, 2 Jul 2013 06:18:28 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73E9E3C27@DBDE04.ent.ti.com>
References: <20130702152954.f25bbf51c1a79aa4437e22ee@canb.auug.org.au>
	<20980858CB6D3A4BAE95CA194937D5E73E9E3BF5@DBDE04.ent.ti.com>
 <CAOesGMgh=CLCrtohrNF59Sh40-weCorL1_yjFgFKr47qhVy+xg@mail.gmail.com>
In-Reply-To: <CAOesGMgh=CLCrtohrNF59Sh40-weCorL1_yjFgFKr47qhVy+xg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Mon, Jul 1, 2013 at 10:44 PM, Gupta, Pekon <pekon@ti.com> wrote:
> >>
> >> Hi all,
> >>
> >> Today's linux-next merge of the arm-soc tree got a conflict in
> >> Documentation/devicetree/bindings/mtd/gpmc-nand.txt between
> commits
> >> 6c88058ef927 ("ARM: OMAP2+: cleaned-up DT support of various ECC
> >> schemes") and 212012138deb ("mtd: nand: omap2: updated support for
> >> BCH4
> >> ECC scheme") from the l2-mtd tree and commit 496c8a0bbb72 ("ARM:
> >> OMAP2+:
> >> Allow NAND transfer mode to be specified in DT") from the arm-soc tree.
> >>
> >> I fixed it up (maybe - see below) and can carry the fix as necessary (no
> >> action is required).
> >>
> >> --
> >> Cheers,
> >> Stephen Rothwell                    sfr@canb.auug.org.au
> >>
> > Yes following merge is correct. Apologies, as there were multiple OMAP2
> NAND and GPMC updates and clean-up going into different trees, so these
> conflict came. Going forward you shouldn't find such issues, as code is more
> stable now. Thanks for help.
> >
> > with regards, pekon
> 
> Sigh. The new bindings seem to never have been reviewed by any device
> tree maintainers, and from the look of it, it might need some
> discussion. It wasn't even cc:d to devicetree-discuss.
> 
> It's completely inappropriate to merge a patch like this at this time
> without any kind of acks from the people reviewing bindings. Can it
> please be dropped ASAP from the MTD tree? Thanks!
> 
> Or, if you want it in different wording: The mtd-tree patch is a
> strong NAK until this has been sorted out.
> 
> It was also applied today, after the merge window opened. Don't merge
> it for 3.11. Artem?
> 
> 
Hi OIof,

You may drop this patch if you wish so, but its not correct to say that this
was not reviewed. Following are comments from "Arnd Bergmann"
http://lists.infradead.org/pipermail/linux-mtd/2013-May/047030.html
And follow-up reasoning..
http://lists.infradead.org/pipermail/linux-mtd/2013-May/047032.html


And based on Arnd's feedbacks patches which contained changes in 
binding string was even dropped from the series, please see 
cover-letter of V3 set below.
http://lists.infradead.org/pipermail/linux-mtd/2013-June/047319.html
- PATCH-4 <DROPPED> update DT attribute for ti,nand-ecc-opt 
	- received feedback to keep DT mapping independent of linuxism
- PATCH-4:<NEW> : ARM: dts: AM33xx: updated default ECC scheme in nand-ecc-opt
	- independent patch for AM335x-evm.dts update based on PATCH-2

So, in case you have objections to same earlier patch where I had
introduced 'linux-based' nomenclature for bindings, that particular
one is already dropped in V3 of this patch series.


with regards, pekon
