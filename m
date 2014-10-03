Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaJCUjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:39:31 -0400
Received: from mail-bn1on0112.outbound.protection.outlook.com ([157.56.110.112]:33434
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750944AbaJCUj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:39:26 -0400
X-Greylist: delayed 1991 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2014 16:39:26 EDT
Message-ID: <1412367858.13320.432.camel@snotra.buserror.net>
Subject: Re: [PATCH 2/2] spi: fsl-spi: Allow dynamic allocation of CPM1
 parameter RAM
From: Scott Wood <scottwood@freescale.com>
To: christophe leroy <christophe.leroy@c-s.fr>
CC: Mark Brown <broonie@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Marcelo Tosatti" <marcelo@kvack.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-spi@vger.kernel.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Fri, 3 Oct 2014 15:24:18 -0500
In-Reply-To: <542F03CF.8010900@c-s.fr>
References: <20141003125609.5BEA11AB276@localhost.localdomain>
	 <20141003144420.GC24441@sirena.org.uk> <542F03CF.8010900@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:2d08:4497:b38c:aeed]
X-ClientProxiedBy: BY1PR0201CA0001.namprd02.prod.outlook.com (25.160.191.139)
 To BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(479174003)(377424004)(199003)(24454002)(189002)(95666004)(107046002)(31966008)(50466002)(62966002)(21056001)(102836001)(85306004)(87976001)(120916001)(99396003)(40100001)(4396001)(50226001)(104166001)(10300001)(77096002)(76482002)(105586002)(76176999)(50986999)(106356001)(122386001)(92566001)(46102003)(97736003)(80022003)(23676002)(103116003)(85852003)(20776003)(86362001)(47776003)(92726001)(101416001)(77156001)(64706001)(93916002)(88136002)(89996001)(42186005)(110136001)(33646002)(87286001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:2d08:4497:b38c:aeed];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 22:15 +0200, christophe leroy wrote:
> Le 03/10/2014 16:44, Mark Brown a écrit :
> > On Fri, Oct 03, 2014 at 02:56:09PM +0200, Christophe Leroy wrote:
> >
> >> +config CPM1_RELOCSPI
> >> +	bool "Dynamic SPI relocation"
> >> +	default n
> >> +	help
> >> +	  On recent MPC8xx (at least MPC866 and MPC885) SPI can be relocated
> >> +	  without micropatch. This activates relocation to a dynamically
> >> +	  allocated area in the CPM Dual port RAM.
> >> +	  When combined with SPI relocation patch (for older MPC8xx) it avoids
> >> +	  the "loss" of additional Dual port RAM space just above the patch,
> >> +	  which might be needed for example when using the CPM QMC.
> > Something like this shouldn't be a compile time option.  Either it
> > should be unconditional or it should be triggered in some system
> > specific manner (from DT, from knowing about other users or similar).
> Can't be unconditional as older versions of mpc8xx (eg MPC860) don't 
> support relocation without a micropatch.
> I have therefore submitted a v2 based on a DTS compatible property.

So the device tree change is about whether relocation is supported, not
whether it is required?  Is this specific to SPI or does the relocation
mechanism work for other things?

How about checking for the existing specific-SoC compatibles?

-Scott


