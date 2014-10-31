Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbaJaQRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:17:06 -0400
Received: from mail-by2on0070.outbound.protection.outlook.com ([207.46.100.70]:34235
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750767AbaJaQRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:17:04 -0400
Date: Fri, 31 Oct 2014 09:16:58 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-api@vger.kernel.org>, Alexandre Courbot <gnurou@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3] gpio: lib-sysfs: Add 'wakeup' attribute
References: <1414434602-14263-1-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdaduj3MaEN=hmL54ANJiP0B5MdH9qSqWRukX4H7pFt_Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaduj3MaEN=hmL54ANJiP0B5MdH9qSqWRukX4H7pFt_Hw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21064.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <f16258a84ebf4797abd4496842c379f2@BN1BFFO11FD009.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(377424004)(51704005)(24454002)(164054003)(51444003)(189002)(199003)(4396001)(99396003)(33646002)(110136001)(46102003)(120916001)(95666004)(50466002)(21056001)(102836001)(106466001)(62966003)(85202003)(53416004)(108616004)(47776003)(31966008)(20776003)(64706001)(74316001)(76176999)(92566001)(44976005)(107046002)(86362001)(19580395003)(19580405001)(83506001)(15975445006)(54356999)(104016003)(50986999)(87936001)(85182001)(23676002)(6806004)(77156002)(77096003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB059;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB059;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 08:03AM +0100, Linus Walleij wrote:
> On Mon, Oct 27, 2014 at 7:30 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > Add an attribute 'wakeup' to the GPIO sysfs interface which allows
> > marking/unmarking a GPIO as wake IRQ.
> > The file 'wakeup' is created in each exported GPIOs directory, if an IRQ
> > is associated with that GPIO and the irqchip implements set_wake().
> > Writing 'enabled' to that file will enable wake for that GPIO, while
> > writing 'disabled' will disable wake.
> > Reading that file will return either 'disabled' or 'enabled' depening on
> > the currently set flag for the GPIO's IRQ.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
> > ---
> > v3:
> >  - add documentation
> > v2:
> >  - fix error path to unlock mutex before return
> (...)
> 
> Looking better!
> 
> > +       "wakeup" ... reads as either "enabled" or "disabled". Write these
> > +               strings to set/clear the 'wakeup' flag of the IRQ associated
> > +               with this GPIO. If the IRQ has the 'wakeup' flag set, it can
> > +               wake the system from sleep states.
> > +
> > +               This file exists only if the pin can generate interrupts and
> > +               the driver implements the required infrastructure.
> 
> Should this not be 0/1 rather than the string "enabled"/"disabled"?
> 
> I think that is the common pattern in sysfs?
> 
> Not sure, but want an indication from the ABI people.

So, as I told Alexandre, 'wakeup' including the values 'enabled' &
'disabled' is how devices that support wake expose this functionality. I
think this is more in line with what already exists. As reference, have
a look at https://www.kernel.org/doc/Documentation/power/devices.txt. It
has a section '/sys/devices/.../power/wakeup files'.

	Thanks,
	Sören
