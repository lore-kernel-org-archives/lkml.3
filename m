Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaJBCeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 22:34:05 -0400
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:16299
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751119AbaJBCeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 22:34:03 -0400
Date: Wed, 1 Oct 2014 19:33:53 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Chris Kohn <ckohn@xilinx.com>, Michal Simek <michal.simek@xilinx.com>,
        Jason Wu <huanyu@xilinx.com>, Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v2] staging: Add Xilinx Clocking Wizard driver
References: <20141001185835.GE23154@mwanda>
 <1412197352-21746-1-git-send-email-soren.brinkmann@xilinx.com>
 <2588006.v8XFKnzbpr@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2588006.v8XFKnzbpr@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20984.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <079c2e82-64cc-4b7b-befe-3cec5afa954c@BN1AFFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(51704005)(164054003)(24454002)(189002)(377424004)(19580395003)(50986999)(110136001)(76176999)(70736001)(76482002)(23676002)(19580405001)(44976005)(99396003)(6806004)(120916001)(95666004)(85852003)(92566001)(33646002)(54356999)(53416004)(107046002)(1496007)(77096002)(50466002)(85202003)(10300001)(87936001)(46102003)(64706001)(20776003)(92726001)(15975445006)(102836001)(106466001)(86362001)(15202345003)(104016003)(74316001)(80022003)(31696002)(31966008)(85182001)(4396001)(21056001)(85306004)(83506001)(47776003)(107986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB020;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03524FBD26
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 02:19AM +0300, Laurent Pinchart wrote:
> Hi Sören,
> 
> Thank you for the patch.
> 
> On Wednesday 01 October 2014 14:02:32 Soren Brinkmann wrote:
> > Add a driver for the Xilinx Clocking Wizard soft IP. The clocking wizard
> > provides an AXI interface to dynamically reconfigure the clocking
> > resources of Xilinx FPGAs.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > Hi Greg, Dan,
> > 
> > I fixed the things Dan pointed out, please take this v2 instead of the
> > original patch.
> > 
> > Also, don't get caught up too much with style issues around the code that
> > registers the clocks. To support set_rate() opeartions this will have to
> > change anyway. It doesn't make a lot of sense to spend much time on those
> > parts.
> > 
> > 	Thanks,
> > 	Sören
> > 
> > v2:
> >  - implement dev_pm_ops
> >  - don't use array for clock inputs
> >  - add more information in error output
> >  - fix style issues
> >  - fix error path
> > ---
> >  drivers/staging/Kconfig                            |   2 +
> >  drivers/staging/Makefile                           |   1 +
> >  drivers/staging/clocking-wizard/Kconfig            |   9 +
> >  drivers/staging/clocking-wizard/Makefile           |   1 +
> >  drivers/staging/clocking-wizard/TODO               |  12 +
> >  .../clocking-wizard/clk-xlnx-clock-wizard.c        | 336 ++++++++++++++++++
> >  drivers/staging/clocking-wizard/dt-binding.txt     |  30 ++
> >  7 files changed, 391 insertions(+)
> >  create mode 100644 drivers/staging/clocking-wizard/Kconfig
> >  create mode 100644 drivers/staging/clocking-wizard/Makefile
> >  create mode 100644 drivers/staging/clocking-wizard/TODO
> >  create mode 100644 drivers/staging/clocking-wizard/clk-xlnx-clock-wizard.c
> >  create mode 100644 drivers/staging/clocking-wizard/dt-binding.txt
> 
> [snip]
> 
> > diff --git a/drivers/staging/clocking-wizard/dt-binding.txt
> > b/drivers/staging/clocking-wizard/dt-binding.txt new file mode 100644
> > index 000000000000..cc3cc5e91440
> > --- /dev/null
> > +++ b/drivers/staging/clocking-wizard/dt-binding.txt
> > @@ -0,0 +1,30 @@
> > +Binding for Xilinx Clocking Wizard IP Core
> > +
> > +This binding uses the common clock binding[1]. Details about the devices
> > can be +found in the product guide[2].
> > +
> > +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +[2] Clocking Wizard Product Guide
> > +http://www.xilinx.com/support/documentation/ip_documentation/clk_wiz/v5_1/p
> > g065-clk-wiz.pdf +
> > +Required properties:
> > + - compatible: Must be 'xlnx,clocking-wizard'
> > + - reg: Base and size of the cores register space
> > + - clocks: Handle to input clock
> > + - clock-names: Tuple containing 'clk_in1' and 's_axi_aclk'
> > + - clock-output-names: Names for the output clocks
> > +
> > +Optional properties:
> > + - speed-grade: Speed grade of the device
> 
> You should document what values are allowed.

Will do.

> > +
> > +Example:
> > +	clock-generator@40040000 {
> > +		reg = <0x40040000 0x1000>;
> > +		compatible = "xlnx,clocking-wizard";
> > +		speed-grade = <(-1)>;
> 
> Can't we make the speed grade positive ? It looks to me that the - is nowadays 
> a dash and not a minus sign, given that higher absolute values of the speed 
> grade mean faster devices. The days when the speed grate represented the 
> propagation time of signals in ns is long gone I suppose.

Fine with me.

	Thanks,
	Sören
