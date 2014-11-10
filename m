Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaKJXC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 18:02:27 -0500
Received: from mail-bn1bon0096.outbound.protection.outlook.com ([157.56.111.96]:60480
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751339AbaKJXC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 18:02:26 -0500
Date: Mon, 10 Nov 2014 15:02:15 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Peter Crosthwaite <crosthwaitepeter@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <michals@xilinx.com>, <sorenb@xilinx.com>,
        Steve Wang <steven.wang@digilentinc.com>
Subject: Re: [PATCH 1/2] arm: dts: zynq: Move crystal freq. to board level
References: <1415504283-31321-1-git-send-email-crosthwaite.peter@gmail.com>
 <38537ddd8ce845cd9929db4ffcb33031@BN1AFFO11FD006.protection.gbl>
 <CAPokK=p-LXJ0C7_Xy8DR0R0k_YrMRKJSMuh5Z48NWR=wmrQwhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPokK=p-LXJ0C7_Xy8DR0R0k_YrMRKJSMuh5Z48NWR=wmrQwhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21090.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <4c9d54e106214449a1602e6a697b822b@BY2FFO11FD018.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(189002)(377454003)(377424004)(51694002)(24454002)(199003)(102836001)(1411001)(54356999)(92566001)(46102003)(64706001)(53416004)(120916001)(23676002)(31966008)(76176999)(47776003)(83506001)(85182001)(20776003)(86362001)(108616004)(110136001)(104016003)(85202003)(4396001)(44976005)(6806004)(107046002)(21056001)(99396003)(62966003)(95666004)(87936001)(77096003)(77156002)(74316001)(50466002)(19580395003)(19580405001)(50986999)(106466001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB025;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB025;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB025;
X-Forefront-PRVS: 039178EF4A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB025;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 08:35AM +1000, Peter Crosthwaite wrote:
> On Mon, Nov 10, 2014 at 7:34 AM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > On Sun, 2014-11-09 at 01:38PM +1000, Peter Crosthwaite wrote:
> >> The fact that all supported boards use the same 33MHz crystal is a
> >> co-incidence. The Zynq PS support a range of crystal freqs so the
> >> hardcoded setting should be removed from the dtsi. Re-implement it
> >> on the board level.
> >>
> >> This prepares support for Zynq boards with different crystal
> >> frequencies (e.g. the Digilent ZYBO).
> >
> > Even with the 33MHz in the dtsi you can override it on the board-level.
> > Just like the 'status' property is overriden in board dts files.
> >
> 
> Do you want the deletion undone? Even with override capability I think
> it should be removed as the number is board level specific and the
> dtsi should be limited to SoC level information.

I'm fine with it. Just wanted to point out that patch 2 does not
strictly require this change and can stand on its own.

[...]
> >> Im guessing long term this should be converted to a fixed clock. But
> >> I think this at least steps in that direction.
> >
> > I was against that since it makes juggling with clock names more
> > difficult. The problem is that the CCF uses a global name space of clock
> > names.
> 
> I thought it was just a
> 
> clocks = < &phandle >
> 
> Where's the namespacing issue?
> 
> Btw I think the clocks=phandle would be populated the the dts as well.
> So the DTSI would have no clocks = node, and the dts must populate it.
> This allows support for an on-board off-soc clock controller
> controlling the PS clock (which is in theory supported by the SoC).

Every call to clk_register needs to be passed in the clock's parent
(unless it's a root clock). That parent is specified by its name. You
won't see it as user/consumer, but when implementing a clock-provider.
I think there is nothing preventing such a change, but it would make
things more complicated for no good reason. Even if you have an off-chip
clock controller, if that one doesn't provide a fixed clock input to
Zynq, things are likely to break.

	Sören
