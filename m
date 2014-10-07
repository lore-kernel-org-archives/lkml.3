Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaJGAUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:20:06 -0400
Received: from mail-by2on0102.outbound.protection.outlook.com ([207.46.100.102]:31040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751098AbaJGATz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:19:55 -0400
Message-ID: <1412641184.13320.506.camel@snotra.buserror.net>
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
Date: Mon, 6 Oct 2014 19:19:44 -0500
In-Reply-To: <542FC8C1.1000707@c-s.fr>
References: <20141003125609.5BEA11AB276@localhost.localdomain>
	 <20141003144420.GC24441@sirena.org.uk> <542F03CF.8010900@c-s.fr>
	 <1412367858.13320.432.camel@snotra.buserror.net> <542FC8C1.1000707@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:6d45:e00c:643e:3f23]
X-ClientProxiedBy: CO2PR11CA0015.namprd11.prod.outlook.com (10.141.242.153) To
 BY2PR0301MB0725.namprd03.prod.outlook.com (25.160.63.155)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0725;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(479174003)(189002)(377424004)(24454002)(199003)(51704005)(86362001)(104166001)(93916002)(20776003)(122386002)(102836001)(95666004)(106356001)(42186005)(110136001)(103116003)(40100002)(107046002)(4396001)(77096002)(50226001)(23676002)(47776003)(97736003)(89996001)(99396003)(76482002)(46102003)(80022003)(101416001)(21056001)(31966008)(76176999)(87286001)(50986999)(105586002)(92566001)(62966002)(87976001)(93886004)(85306004)(33646002)(85852003)(92726001)(120916001)(50466002)(10300001)(77156001)(88136002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0725;H:[IPv6:2601:2:5800:3f7:6d45:e00c:643e:3f23];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-04 at 12:15 +0200, christophe leroy wrote:
> Le 03/10/2014 22:24, Scott Wood a écrit :
> > On Fri, 2014-10-03 at 22:15 +0200, christophe leroy wrote:
> >> Le 03/10/2014 16:44, Mark Brown a écrit :
> >>> On Fri, Oct 03, 2014 at 02:56:09PM +0200, Christophe Leroy wrote:
> >>>
> >>>> +config CPM1_RELOCSPI
> >>>> +	bool "Dynamic SPI relocation"
> >>>> +	default n
> >>>> +	help
> >>>> +	  On recent MPC8xx (at least MPC866 and MPC885) SPI can be relocated
> >>>> +	  without micropatch. This activates relocation to a dynamically
> >>>> +	  allocated area in the CPM Dual port RAM.
> >>>> +	  When combined with SPI relocation patch (for older MPC8xx) it avoids
> >>>> +	  the "loss" of additional Dual port RAM space just above the patch,
> >>>> +	  which might be needed for example when using the CPM QMC.
> >>> Something like this shouldn't be a compile time option.  Either it
> >>> should be unconditional or it should be triggered in some system
> >>> specific manner (from DT, from knowing about other users or similar).
> >> Can't be unconditional as older versions of mpc8xx (eg MPC860) don't
> >> support relocation without a micropatch.
> >> I have therefore submitted a v2 based on a DTS compatible property.
> > So the device tree change is about whether relocation is supported, not
> > whether it is required?
> Indeed no, my intension is to say that relocation is requested. Do you 
> mean that it should then not use a compatible ?

The device tree describes hardware.  It doesn't tell software how to use
that hardware.

Based on one of your other e-mails, I think what you want to say here is
that the old binding didn't describe the registers needed for
relocation, so the new compatible describes the new binding, rather than
requesting that software do a relocation.  Software that sees the new
binding could choose to relocate, or just choose to read the current
offset from the register.

> > How about checking for the existing specific-SoC compatibles?
> What do you mean ?

Look for "fsl,mpc885-cpm-i2c" etc.  Or, if you didn't follow that
pattern (remember, I can't see your device tree!), look for
"fsl,mpc885-cpm" or "fsl,mpc866-cpm" in the parent node.  It's moot
though, if the device tree also needs to be modified to describe the
register used to relocate.

-Scott


