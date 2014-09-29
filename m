Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaI3AOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:14:05 -0400
Received: from mail-bl2on0116.outbound.protection.outlook.com ([65.55.169.116]:22895
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751906AbaI3AOD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:14:03 -0400
Message-ID: <1412035075.13320.302.camel@snotra.buserror.net>
Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
From: Scott Wood <scottwood@freescale.com>
To: Tang Yuantian-B29983 <Yuantian.Tang@freescale.com>
CC: Mike Turquette <mturquette@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lu Jingchang-B35083 <jingchang.lu@freescale.com>
Date: Mon, 29 Sep 2014 18:57:55 -0500
In-Reply-To: <d637914864824bda8d0dd62639e9097b@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
	 <d4a375f40b544cf1ae78ac82dc20569c@BL2PR03MB467.namprd03.prod.outlook.com>
	 <1411675680.13320.201.camel@snotra.buserror.net>
	 <20140925225406.19023.25065@quantum>
	 <1411685780.13320.209.camel@snotra.buserror.net>
	 <20140926232900.19023.35854@quantum>
	 <d637914864824bda8d0dd62639e9097b@DM2PR03MB574.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:cc8b:f9eb:f03b:cf1d]
X-ClientProxiedBy: BN1PR02CA0049.namprd02.prod.outlook.com (10.141.56.49) To
 BN1PR0301MB0721.namprd03.prod.outlook.com (25.160.78.140)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-Forefront-PRVS: 034902F5BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377424004)(189002)(377454003)(199003)(51704005)(24454002)(13464003)(93916002)(10300001)(76482002)(21056001)(64706001)(62966002)(120916001)(86362001)(19580405001)(19580395003)(99396003)(85306004)(93886004)(104166001)(4396001)(50226001)(20776003)(47776003)(107046002)(50986999)(31966008)(103116003)(23676002)(88136002)(87286001)(87976001)(92726001)(92566001)(101416001)(42186005)(46102003)(89996001)(76176999)(102836001)(80022003)(85852003)(110136001)(95666004)(97736003)(106356001)(33646002)(77156001)(77096002)(105586002)(50466002)(21314002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0721;H:[IPv6:2601:2:5800:3f7:cc8b:f9eb:f03b:cf1d];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-09-27 at 21:18 -0500, Tang Yuantian-B29983 wrote:
> > -----Original Message-----
> > From: Linuxppc-dev
> > [mailto:linuxppc-dev-bounces+b29983=freescale.com@lists.ozlabs.org] On
> > Behalf Of Mike Turquette
> > Sent: Saturday, September 27, 2014 7:29 AM
> > To: Wood Scott-B07421
> > Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> > linux-arm-kernel@lists.infradead.org; Lu Jingchang-B35083
> > Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
> > CLK_OF_DECLARE support
> > 
> > Quoting Scott Wood (2014-09-25 15:56:20)
> > > On Thu, 2014-09-25 at 15:54 -0700, Mike Turquette wrote:
> > > > Quoting Scott Wood (2014-09-25 13:08:00)
> > > > > Well, like I said, I'd rather see the CLK_OF_DECLARE stuff be made
> > > > > to work on PPC rather than have the driver carry around two
> > > > > binding methods.
> > > >
> > > > I guess that is an existing problem, and not related directly to
> > > > this patch? This patch is essentially just renames (though the
> > > > V1.0/V2.0 stuff seems weird).
> > >
> > > This patch is adding CLK_OF_DECLARE.
> > 
> > I'm fine taking this patch but your comments are still unresolved. What do you
> > think needs to be done to fix the problems that you see?
> > 
> CLK_OF_DECLARE is totally worked on PPC. I will do it in a separate patch.
> Regarding V1.0 and V2.0, it is not wired just same for now. But we are not sure if it is same for v3.0 in the future.
> 
> Besides updating drivers/cpufreq/Kconfig.powerpc, there is one more thing I am not comfortable with:
> This patch uses " fixed-clock" as sysclk's compatible string, while on PPC we treated it as " fsl,qoriq-sysclk-[1-2].0".
> That's inconsistent on both ARM and PPC platforms, neither did on bindings.

fsl,qoriq-sysclk-XXX is the way it is because of compatibility with the
fixups in existing U-Boots.  It shouldn't be used as a model.

That said, I don't think you really mean "this patch", as it doesn't
contain the device tree updates, and "fixed-clock" does not appear.

-Scott


