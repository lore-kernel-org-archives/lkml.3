Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbbAPRFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:05:06 -0500
Received: from mail-bn1on0060.outbound.protection.outlook.com ([157.56.110.60]:52576
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752154AbbAPRFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:05:02 -0500
X-Greylist: delayed 88041 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2015 12:05:02 EST
Date: Fri, 16 Jan 2015 08:49:17 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Johan Hovold <johan@kernel.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-api@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4] gpio: lib-sysfs: Add 'wakeup' attribute
References: <1421351389-11660-1-git-send-email-soren.brinkmann@xilinx.com>
 <20150116111108.GG30960@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150116111108.GG30960@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21258.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <a4610e13d0094d40b7e0574992509ec6@BN1AFFO11FD044.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(377424004)(51704005)(24454002)(199003)(19580405001)(85182001)(87936001)(83506001)(77156002)(19580395003)(6806004)(2950100001)(53416004)(92726002)(46102003)(110136001)(76176999)(50986999)(54356999)(106466001)(85202003)(104016003)(108616004)(92566002)(33646002)(86362001)(62966003)(47776003)(23676002)(74316001)(50466002)(64706001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB028;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB028;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1AFFO11HUB028;
X-Forefront-PRVS: 04583CED1A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB028;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2015 16:49:19.8335
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1AFFO11HUB028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-16 at 12:11PM +0100, Johan Hovold wrote:
> On Thu, Jan 15, 2015 at 11:49:49AM -0800, Soren Brinkmann wrote:
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
> > Hi Linus, Johan,
> > 
> > I rebased my patch. And things look good.
> 
> I took at closer look at this patch now and I really don't think it
> should be merged at all.
> 
> We have a mechanism for handling wake-up sources (documented in
> Documentation/power/devices.txt) as well as an ABI to enable/disable
> them using the power/wakeup device attribute from userspace.

Doesn't work for GPIOs AFAIK.

> 
> Implementing proper wakeup support for unclaimed GPIOs would take some
> work (if at all desired), but that is not a reason to be adding custom
> implementations that violates the kernel's power policies and new ABIs
> that would need to be maintained forever.

These are claimed, by the sysfs interface.

> 
> [ And we really shouldn't be adding anything to the broken gpio sysfs
> interface until it's been redesigned. ]
> 
> Meanwhile you can (should) use gpio-keys if you need to wake your system
> on gpio events.

We had that discussion and I don't think GPIO keys is the right solution
for every use-case.

> 
> > But the 'is_visible' things does not behave the way I expected it to.
> > It seems to be only triggered on an export but not when attributes
> > change. Hence, in my case, everything was visiible since the inital
> > state matches that, but even when changing the direction or things
> > like that, attributes don't disappear. Is that something still worked
> > on? Expected
> 
> That's expected. We generally don't want attributes to appear or
> disappear after the device has been registered (although there is a
> mechanism for cases were it makes sense). This is no different from
> how your v3 patch worked either.

Sure, but the is_visible thing is effectively broken for GPIO. I think a
GPIO is in a defined state when exported and the checks all work on that
state during export. But then this state can be changed through the
sysfs interface. So, if the initial state hides something it becomes
unavailable for all times and, vice versa, if the initial state makes
something visible, it will stay even when it is no longer a valid
property to change.

	Sören
