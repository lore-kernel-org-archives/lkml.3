Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935279AbaKNPFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:05:31 -0500
Received: from mail-bl2on0081.outbound.protection.outlook.com ([65.55.169.81]:54184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935237AbaKNPF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:05:27 -0500
Date: Fri, 14 Nov 2014 07:05:14 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Kedareswara rao Appana <appana.durga.rao@xilinx.com>, <wg@grandegger.com>,
        <michal.simek@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v2] can: Fix bug in suspend/resume
References: <e7070431858e49e29cd03d76fd7a66c3@BN1AFFO11FD055.protection.gbl>
 <5465C34D.4030805@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5465C34D.4030805@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21104.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <e5f5913b51a54222aa1bb0680a77e56d@BN1AFFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(479174003)(377424004)(24454002)(199003)(51704005)(164054003)(189002)(95666004)(47776003)(20776003)(64706001)(120916001)(50986999)(46102003)(54356999)(107046002)(21056001)(77156002)(44976005)(77096003)(85202003)(4396001)(74316001)(62966003)(50466002)(110136001)(19580405001)(104016003)(106466001)(99396003)(33646002)(76176999)(108616004)(53416004)(19580395003)(87936001)(92566001)(83506001)(102836001)(6806004)(86362001)(85182001)(31966008)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB040;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB040;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB040;
X-Forefront-PRVS: 03950F25EC
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB040;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 09:54AM +0100, Marc Kleine-Budde wrote:
> On 11/14/2014 09:16 AM, Kedareswara rao Appana wrote:
> > The drvdata in the suspend/resume is of type struct net_device,
> > not the platform device.Enable the clocks in the suspend before
> > accessing the registers of the CAN.
> > 
> > Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> > ---
> > Changes for v2:
> >   - Removed the struct platform_device* from suspend/resume
> >     as suggest by Lothar.
> >   - The clocks are getting disabled and un prepared at the end of the probe. 
> >     In the suspend the driver is doing a register write.In order
> >     To do that register write we have to again enable and prepare the clocks.
> 
> Please look the at suspend/resume code and count the
> clock_enable/disable manually. After a suspend/resume cycle, you have
> enabled the clock twice, but disabled it once.
> 
> I think you have to abstract the clock handling behind runtime PM. I
> haven't done this myself yet, but the strong feeling that this is a
> possible solution to your problem. These links might help:

I agree, the clock handling looks weird. Also the clk_disable calls in
xcan_get_berr_counter() look suspicious to me, but I might be wrong.
I think you can take a look at gpio-zynq for an example for runtime_pm
usage. I think the usage model in that driver is similar to here.

	Thanks,
	Sören
