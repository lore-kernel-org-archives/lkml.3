Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaJHXsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:48:40 -0400
Received: from mail-bn1on0134.outbound.protection.outlook.com ([157.56.110.134]:26336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750979AbaJHXsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:48:31 -0400
Message-ID: <1412812099.13320.547.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
From: Scott Wood <scottwood@freescale.com>
To: Jia Hongtao-B38951 <hongtao.jia@freescale.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jojy G Varghese <jojyv@juniper.net>,
        "Guenter Roeck" <groeck@juniper.net>
Date: Wed, 8 Oct 2014 18:48:19 -0500
In-Reply-To: <cfa12996b9a54b3baaa75f517f78c7ea@BLUPR03MB149.namprd03.prod.outlook.com>
References: <1412009312-7400-1-git-send-email-linux@roeck-us.net>
	 <1412015766.13320.253.camel@snotra.buserror.net>
	 <cfa12996b9a54b3baaa75f517f78c7ea@BLUPR03MB149.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:8d24:400:3af9:c4bd]
X-ClientProxiedBy: BY2PR04CA035.namprd04.prod.outlook.com (10.141.249.153) To
 BN1PR0301MB0722.namprd03.prod.outlook.com (25.160.78.141)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0722;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(377424004)(51704005)(13464003)(24454002)(189002)(199003)(120916001)(99396003)(76482002)(77156001)(23676002)(21056001)(89996001)(85852003)(88136002)(19580405001)(19580395003)(104166001)(64706001)(15975445006)(87286001)(122386002)(40100002)(50466002)(87976001)(20776003)(47776003)(93916002)(86362001)(4396001)(50226001)(105586002)(97736003)(106356001)(102836001)(15202345003)(95666004)(42186005)(62966002)(92566001)(92726001)(46102003)(101416001)(80022003)(33646002)(50986999)(107046002)(103116003)(85306004)(110136001)(77096002)(76176999)(31966008)(99106002)(7059025)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0722;H:[IPv6:2601:2:5800:3f7:8d24:400:3af9:c4bd];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 22:08 -0500, Jia Hongtao-B38951 wrote:
> 
> > -----Original Message-----
> > From: Wood Scott-B07421
> > Sent: Tuesday, September 30, 2014 2:36 AM
> > To: Guenter Roeck
> > Cc: Benjamin Herrenschmidt; Paul Mackerras; Michael Ellerman; linuxppc-
> > dev@lists.ozlabs.org; linux-kernel@vger.kernel.org; Jojy G Varghese;
> > Guenter Roeck; Jia Hongtao-B38951
> > Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
> > exception on E500MC / E5500
> > 
> > On Mon, 2014-09-29 at 09:48 -0700, Guenter Roeck wrote:
> > > From: Jojy G Varghese <jojyv@juniper.net>
> > >
> > > For E500MC and E5500, a machine check exception in pci(e) memory space
> > > crashes the kernel.
> > >
> > > Testing shows that the MCAR(U) register is zero on a MC exception for
> > > the
> > > E5500 core. At the same time, DEAR register has been found to have the
> > > address of the faulty load address during an MC exception for this core.
> > >
> > > This fix changes the current behavior to fixup the result register and
> > > instruction pointers in the case of a load operation on a faulty PCI
> > > address.
> > >
> > > The changes are:
> > > - Added the hook to pci machine check handing to the e500mc machine
> > check
> > >   exception handler.
> > > - For the E5500 core, load faulting address from SPRN_DEAR register.
> > >   As mentioned above, this is necessary because the E5500 core does not
> > >   report the fault address in the MCAR register.
> > >
> > > Cc: Scott Wood <scottwood@freescale.com>
> > > Signed-off-by: Jojy G Varghese <jojyv@juniper.net> [Guenter Roeck:
> > > updated description]
> > > Signed-off-by: Guenter Roeck <groeck@juniper.net>
> > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > ---
> > >  arch/powerpc/kernel/traps.c   | 3 ++-
> > >  arch/powerpc/sysdev/fsl_pci.c | 5 +++++
> > >  2 files changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> > > index 0dc43f9..ecb709b 100644
> > > --- a/arch/powerpc/kernel/traps.c
> > > +++ b/arch/powerpc/kernel/traps.c
> > > @@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs *regs)
> > >  	int recoverable = 1;
> > >
> > >  	if (reason & MCSR_LD) {
> > > -		recoverable = fsl_rio_mcheck_exception(regs);
> > > +		recoverable = fsl_rio_mcheck_exception(regs) ||
> > > +			fsl_pci_mcheck_exception(regs);
> > >  		if (recoverable == 1)
> > >  			goto silent_out;
> > >  	}
> > > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> > > b/arch/powerpc/sysdev/fsl_pci.c index c507767..bdb956b 100644
> > > --- a/arch/powerpc/sysdev/fsl_pci.c
> > > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > > @@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct pt_regs
> > > *regs)  #endif
> > >  	addr += mfspr(SPRN_MCAR);
> > >
> > > +#ifdef CONFIG_E5500_CPU
> > > +	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
> > > +		addr = PFN_PHYS(vmalloc_to_pfn((void *)mfspr(SPRN_DEAR)));
> > #endif
> > 
> > Kconfig tells you what hardware is supported, not what hardware you're
> > actually running on.
> > 
> > Jia Hongtao, do you know anything about this issue?  Is there an erratum?
> 
> Sorry for the late response, I just return from my vacation.
> I don't know this issue.
> 
> > What chips are affected by the the erratum covered by
> > <http://patchwork.ozlabs.org/patch/240239/>?
> 
> MPC8544, MPC8548, MPC8572 are affected by this erratum.

What is the erratum number?

> I checked P4080 which using e500mc and no such erratum is found.

What is the erratum behavior, and how does it differ from the problem
that Jojy and Guenter are trying to solve?

-Scott


