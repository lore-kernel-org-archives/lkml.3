Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaHSWa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 18:30:57 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:44363
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751398AbaHSWaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 18:30:55 -0400
Message-ID: <1408487444.4058.40.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc: Make 256k pages depend on PPC32=n
From: Scott Wood <scottwood@freescale.com>
To: Pranith Kumar <bobby.prani@gmail.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "open list:LINUX FOR POWERPC..." <linuxppc-dev@lists.ozlabs.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 19 Aug 2014 17:30:44 -0500
In-Reply-To: <CAJhHMCAA3rLkszp=Fk9mC81f9+qe8JU_TB6RG3rzdnmpR07jJA@mail.gmail.com>
References: <1408484166-20711-1-git-send-email-bobby.prani@gmail.com>
	 <1408486751.4058.37.camel@snotra.buserror.net>
	 <CAJhHMCAA3rLkszp=Fk9mC81f9+qe8JU_TB6RG3rzdnmpR07jJA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:70b6:fbcb:548e:4486]
X-ClientProxiedBy: BN1PR08CA0039.namprd08.prod.outlook.com (10.242.217.167) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0308EE423E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019006)(6009001)(377424004)(377454003)(51704005)(54094003)(24454002)(189002)(199003)(46102001)(42186005)(102836001)(76176999)(64706001)(77156001)(33646002)(110136001)(47776003)(19580405001)(20776003)(81542001)(23676002)(99396002)(50986999)(104166001)(105586002)(85306004)(31966008)(19580395003)(92726001)(93916002)(86362001)(62966002)(74502001)(103116003)(106356001)(81342001)(50226001)(76482001)(92566001)(95666004)(88136002)(79102001)(83072002)(21056001)(87976001)(74662001)(101416001)(50466002)(4396001)(80022001)(83322001)(77982001)(89996001)(107046002)(87286001)(77096002)(85852003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:70b6:fbcb:548e:4486];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-08-19 at 18:23 -0400, Pranith Kumar wrote:
> On Tue, Aug 19, 2014 at 6:19 PM, Scott Wood <scottwood@freescale.com> wrote:
> 
> >>  config PPC_256K_PAGES
> >>       bool "256k page size" if 44x
> >> -     depends on !STDBINUTILS
> >> +     depends on !PPC32 && !STDBINUTILS
> >>       help
> >>         Make the page size 256k.
> >>
> >
> > How will this ever be selected then?  44x is 32-bit only.
> 
> Indeed. I am actually confused about the error which is being thrown
> here. The operand (65536) is actually within the range. Any suggestions
> on how to fix this?

It's not within range of "li".  I wonder if whatever non-"STD" binutils
this is supposed to be used with is rewriting it into an lis
instruction.  This sort of external dependency is a poor fit for the
randconfig concept (plus, shouldn't the symbol be indicating what
binutils you're supposed to have rather than anything that isn't
"standard"?).

In any case, you could use something like LOAD_REG_IMMEDIATE().

-Scott


