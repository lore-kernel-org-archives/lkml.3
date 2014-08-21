Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaHUTCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:02:44 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:27374
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752170AbaHUTCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:02:42 -0400
Date: Thu, 21 Aug 2014 12:02:35 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH 9/9] ARM: zynq: Rename 'zynq_platform_cpu_die'
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
 <1408567315-28479-10-git-send-email-soren.brinkmann@xilinx.com>
 <4ac42f4d-72bf-4a8d-a997-094f129d7c74@BN1AFFO11FD020.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4ac42f4d-72bf-4a8d-a997-094f129d7c74@BN1AFFO11FD020.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <9c7c26e1-4098-4252-a719-fb7b7205be61@BN1AFFO11FD006.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(377424004)(189002)(24454002)(199003)(479174003)(377454003)(23676002)(85852003)(79102001)(74662001)(85306004)(20776003)(50466002)(81342001)(80022001)(6806004)(44976005)(77982001)(21056001)(83322001)(70736001)(83506001)(53416004)(90102001)(46102001)(19580405001)(19580395003)(107046002)(86362001)(85202003)(77096002)(47776003)(81542001)(102836001)(92566001)(31696002)(106466001)(74316001)(83072002)(99396002)(95666004)(76482001)(74502001)(92726001)(54356999)(31966008)(4396001)(87936001)(64706001)(76176999)(104016003)(85182001)(1496007)(33646002)(50986999)(110136001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB023;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:3;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
Authentication-Results: spf=temperror (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 02:28PM +0200, Michal Simek wrote:
> On 08/20/2014 10:41 PM, Soren Brinkmann wrote:
> > Match the naming pattern of all other SMP ops and rename
> > zynq_platform_cpu_die --> zynq_cpu_die.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >  arch/arm/mach-zynq/platsmp.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
> > index 04e578718aa2..95933c5e70e1 100644
> > --- a/arch/arm/mach-zynq/platsmp.c
> > +++ b/arch/arm/mach-zynq/platsmp.c
> > @@ -138,7 +138,7 @@ static int zynq_cpu_kill(unsigned cpu)
> >   *
> >   * Called with IRQs disabled
> >   */
> > -static void zynq_platform_cpu_die(unsigned int cpu)
> > +static void zynq_cpu_die(unsigned int cpu)
> >  {
> >  	zynq_slcr_cpu_state_write(cpu, true);
> >  
> > @@ -158,7 +158,7 @@ struct smp_operations zynq_smp_ops __initdata = {
> >  	.smp_boot_secondary	= zynq_boot_secondary,
> >  	.smp_secondary_init	= zynq_secondary_init,
> >  #ifdef CONFIG_HOTPLUG_CPU
> > -	.cpu_die		= zynq_platform_cpu_die,
> > +	.cpu_die		= zynq_cpu_die,
> >  	.cpu_kill		= zynq_cpu_kill,
> >  #endif
> >  };
> 
> Will be good if you can move fix that kernel-doc format for this function
> too. It is just nice to have thing.

All these SMP-ops should be documented in the header defining that
struct, shouldn't they?

	Sören

