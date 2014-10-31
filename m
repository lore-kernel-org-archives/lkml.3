Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaJaQ5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:57:52 -0400
Received: from mail-bn1on0053.outbound.protection.outlook.com ([157.56.110.53]:1928
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753678AbaJaQ5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:57:50 -0400
Date: Fri, 31 Oct 2014 09:57:43 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZjJQTxVhvq5BT3mHBDHge_wHBNi9N_6u0WVbPB3wBDKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21064.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <030ed753d9764825b1bd5c845b360c7d@BN1AFFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(199003)(51704005)(377454003)(24454002)(189002)(76176999)(23676002)(85182001)(20776003)(87936001)(19580395003)(6806004)(92566001)(102836001)(64706001)(47776003)(86362001)(50986999)(31966008)(74316001)(4396001)(21056001)(77096003)(77156002)(54356999)(83506001)(104016003)(108616004)(93886004)(50466002)(46102003)(110136001)(33646002)(95666004)(85202003)(19580405001)(44976005)(106466001)(99396003)(107046002)(53416004)(120916001)(62966003)(107986001)(24736002)(217873001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB017;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB017;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03818C953D
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 09:17AM +0100, Linus Walleij wrote:
> On Tue, Oct 28, 2014 at 5:03 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> > On Tue, 2014-10-28 at 04:05PM +0100, Linus Walleij wrote:
> >> On Thu, Oct 16, 2014 at 7:11 PM, Soren Brinkmann
> >> <soren.brinkmann@xilinx.com> wrote:
> >>
> >> > Add pinctrl descriptions to the zc702 and zc706 device trees.
> >> >
> >> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >>
> >> (...)
> >> > +&pinctrl0 {
> >> > +       pinctrl_can0_default: pinctrl-can0-default {
> >> > +               common {
> >> > +                       function = "can0";
> >> > +                       groups = "can0_9_grp";
> >> > +                       bias-pull-up = <0>;
> >>
> >> No. If you want pull-up, just use
> >> bias-pull-up;
> >>
> >> If you want to disable pull-up, use
> >> bias-disable;
> >
> > But bias-disable also disables high-impedance. That doesn't work for me,
> > I think.
> 
> Hm. Some sequencing problem right? Like you count on
> bias-high-impdedance being set in some other state?
> 
> I think each state should be self-contained, so you set
> all the stuff you need in a state, do not rely on things coming
> in pre-set from another state.
> 
> So in this case just set bias-high-impedance; then and
> if the state does not have bias-pull-up, *always* disable it
> in the driver.
> 
> >>
> >> > +                       slew-rate = <0>;
> >>
> >> If this measure is any kind of time unit, this is against the laws of nature.
> >
> > It's not. As the bindings say, the argument is driver specific.
> 
> Okay then.
> 
> >> > +               rx {
> >> > +                       pins = "MIO46";
> >> > +                       bias-high-impedance = <1>;
> >>
> >> Just
> >> bias-high-impedance;
> >
> > Same problem as I have above. To allow all permutations of pull-up and
> > tri-state I can't just have a single disable-bias property.
> 
> Again it seems to be a sequencing problem. And device tree is
> not good at sequences, therefore all states should be self-contained.

I agree, but how would I define a pin with pull-up enabled and
tri-state disabled - assume the pin is currently in a random state that
can have those things set/not set arbitrarily.

I don't see how that can be handled without using arguments the way I
proposed.

I can't put bias-disable in DT since it would potentially disable both
and the pull-up enable would have only a transient effect.
I can't do the sequencing in the driver either. If I see pull-up enable,
I can't imply an effect on tri-state since I can't know whether there
was/will be a tri-state property that sets it as well.

	Sören
