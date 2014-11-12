Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaKLS03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:26:29 -0500
Received: from mail-bn1bon0076.outbound.protection.outlook.com ([157.56.111.76]:25052
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751685AbaKLS01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:26:27 -0500
X-Greylist: delayed 7971 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Nov 2014 13:26:26 EST
Date: Wed, 12 Nov 2014 10:26:03 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Vinod Koul <vinod.koul@intel.com>, <dmaengine@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH RESEND] Documentation: devicetree: Fix Xilinx VDMA
 specification
References: <1415800277-6817-1-git-send-email-afaerber@suse.de>
 <6067bede14b9421fa87db96bdc66dc66@BN1AFFO11FD040.protection.gbl>
 <5463A0F4.6060300@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5463A0F4.6060300@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21096.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <bd47278216b64375b32cdc9ed66fe907@BN1BFFO11FD024.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(24454002)(189002)(199003)(51704005)(164054003)(377424004)(23676002)(53416004)(46102003)(86362001)(31966008)(120916001)(20776003)(47776003)(64706001)(106466001)(110136001)(21056001)(99396003)(108616004)(33646002)(107046002)(44976005)(19580405001)(77156002)(6806004)(95666004)(92566001)(50466002)(102836001)(50986999)(83506001)(76176999)(85202003)(19580395003)(74316001)(4396001)(15975445006)(54356999)(87936001)(62966003)(85182001)(104016003)(77096003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB050;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB050;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB050;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=temperror (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB050;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-12 at 07:03PM +0100, Andreas Färber wrote:
> Am 12.11.2014 um 16:57 schrieb Sören Brinkmann:
> > On Wed, 2014-11-12 at 02:51PM +0100, Andreas Färber wrote:
> >> The specification requires xlnx,data-width, but example and driver use
> >> xlnx,datawidth. Change the specification to match the implementation.
> > 
> > Isn't this the wrong way around? The bindings are considered API, so
> > shouldn't the driver be fixed to match the spec?
> 
> In theory, patch review should've never let the two differ... ;)
> 
> It's not my driver, so I fixed the perceived inconsistency the least
> invasive way; Michal and Srikanth seemed to concur at the time.
> 
> https://patchwork.kernel.org/patch/4620261/
> 
> > Are there already dts files out there using either of these options?
> 
> In upstream, no. microblaze and virtex440 use a
> xlnx,include-datawidth-matching-0 property as precedence for the
> spelling, whereas there is an fsl,data-width and an unused msix-data-width.
> 
> Downstream, yes: Beyond my own patch derived from the Parallella tree,
> there's some in the ADI tree. None in the Xilinx tree on quick check.
> 
> I haven't encountered any using the documented xlnx,data-width - but
> this patch was authored pre 3.17, haven't ran a full Web search again.

grepping through linux-next shows some usage of xlnx,datawidth, but
only the single hit in  Documentation for xlnx,data-width.
Other than VDMA the other hit seems to be just some DT
documentation which I can't find a driver for...
Anyhow, this patch is probably the best way of fixing this.

Reviewed-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Thanks,
	Sören
