Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaKBUUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 15:20:52 -0500
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:8368
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751093AbaKBUUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 15:20:50 -0500
Date: Sun, 2 Nov 2014 12:20:41 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [PATCH RFC v2 8/8] ARM: zynq: DT: Add pinctrl information
References: <1413479495-14206-1-git-send-email-soren.brinkmann@xilinx.com>
 <1413479495-14206-9-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkda9v=H9rQBq484c+UCwEKeca9qOE_78Wf+STB4rDwhuyA@mail.gmail.com>
 <5cf5e2e5cd154992b2896b98988a409a@BN1BFFO11FD007.protection.gbl>
 <CACRpkdZjJQTxVhvq5BT3mHBDHge_wHBNi9N_6u0WVbPB3wBDKw@mail.gmail.com>
 <030ed753d9764825b1bd5c845b360c7d@BN1AFFO11FD036.protection.gbl>
 <CACRpkdb9Gg90GwTpUm7S6SFkFjKTRaZLWa2JLnXJK4H-ZMbQ6A@mail.gmail.com>
 <4a2cb923ab264d7d99107a450d6ddcba@BN1BFFO11FD057.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4a2cb923ab264d7d99107a450d6ddcba@BN1BFFO11FD057.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21070.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <f2781e379e3348e39d30cb77b0dbca40@BN1AFFO11FD042.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377454003)(51704005)(24454002)(199003)(377424004)(189002)(76176999)(50986999)(106466001)(85182001)(54356999)(85202003)(46102003)(50466002)(53416004)(87936001)(102836001)(83506001)(21056001)(86362001)(95666004)(23676002)(19580395003)(44976005)(19580405001)(62966003)(77096003)(77156002)(120916001)(6806004)(99396003)(64706001)(20776003)(47776003)(4396001)(33646002)(104016003)(74316001)(110136001)(107046002)(108616004)(107986001)(24736002)(23106004)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB017;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB017;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03838E948C
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 10:40AM -0700, Sören Brinkmann wrote:
> On Fri, 2014-10-31 at 06:36PM +0100, Linus Walleij wrote:
> > On Fri, Oct 31, 2014 at 5:57 PM, Sören Brinkmann
> > <soren.brinkmann@xilinx.com> wrote:
> > > On Fri, 2014-10-31 at 09:17AM +0100, Linus Walleij wrote:
> > 
> > >> Again it seems to be a sequencing problem. And device tree is
> > >> not good at sequences, therefore all states should be self-contained.
> > >
> > > I agree, but how would I define a pin with pull-up enabled and
> > > tri-state disabled - assume the pin is currently in a random state that
> > > can have those things set/not set arbitrarily.
> > 
> > I was more thinking as everything you don't enable explicitly
> > in a state is per definition disabled.
> > 
> > So if you are in state A and tri-state is enabled there and you
> > move to state B where pull-up is enabled, then tri-state should
> > be disabled, since it is not explicitly enabled.
> > 
> > > I can't put bias-disable in DT since it would potentially disable both
> > > and the pull-up enable would have only a transient effect.
> > 
> > Well look at the callback from the core:
> > 
> >         int (*pin_config_set) (struct pinctrl_dev *pctldev,
> >                                unsigned pin,
> >                                unsigned long *configs,
> >                                unsigned num_configs);
> > 
> > You get all configs in an array. The driver can walk over the list and
> > make informed decisions on what to do *BEFORE* poking any registers.
> > 
> > Avoiding transients as you describe is part of why the callback
> > looks as it does. This is why every driver has its own for-loop.
> 
> Okay, I guess that is possible. I find usage of the arguments more
> elegant since it is more explicit and reduces code in the driver, but I
> suspect it should work.

It does work with some limitation though.
This was how I originally described a state in DT:
	pinctrl_uart1_default: pinctrl-uart1-default {
		common {
			groups = "uart1_10_grp";
			function = "uart1";
			bias-pull-up = <0>;
			slew-rate = <0>;
			io-standard = <1>;
		};
	
		rx {
			pins = "MIO49";
			bias-high-impedance = <1>;
		};
	
		tx {
			pins = "MIO48";
			bias-high-impedance = <0>;
		};
	};

Now, I removed the arguments for tri-state and pull-up. The problem,
this state is handled per-sub-node. I.e. one call to the cfg-set
callback per node. I.e. I cannot split things in common, rx and tx, but
I need to duplicate the pinconf props in rx and tx, resulting in:
	pinctrl_uart1_default: pinctrl-uart1-default {
		common {
			groups = "uart1_10_grp";
			function = "uart1";
		};

		rx {
			pins = "MIO49";
			slew-rate = <0>;
			io-standard = <1>;
			bias-high-impedance;
		};

		tx {
			pins = "MIO48";
			slew-rate = <0>;
			io-standard = <1>;
		};
	};

In a nutshell, yes, it's possible to work without the arguments for
pull-up or tri-state. But it adds complexity in the driver and the DT
description.

	Sören
