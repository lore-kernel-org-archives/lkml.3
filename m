Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaJ1QDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:03:14 -0400
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:3697
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbaJ1QDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:03:13 -0400
Date: Tue, 28 Oct 2014 09:03:06 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkda9v=H9rQBq484c+UCwEKeca9qOE_78Wf+STB4rDwhuyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21058.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <5cf5e2e5cd154992b2896b98988a409a@BN1BFFO11FD007.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(199003)(189002)(377424004)(24454002)(377454003)(95666004)(50986999)(120916001)(76176999)(50466002)(85202003)(53416004)(33646002)(6806004)(108616004)(104016003)(19580405001)(77096002)(107046002)(54356999)(110136001)(85182001)(31966008)(21056001)(47776003)(86362001)(64706001)(4396001)(19580395003)(85306004)(20776003)(44976005)(102836001)(76482002)(87936001)(46102003)(23676002)(80022003)(74316001)(106466001)(85852003)(83506001)(92566001)(107986001)(24736002)(217873001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB050;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB050;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0378F1E47A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 04:05PM +0100, Linus Walleij wrote:
> On Thu, Oct 16, 2014 at 7:11 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > Add pinctrl descriptions to the zc702 and zc706 device trees.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> (...)
> > +&pinctrl0 {
> > +       pinctrl_can0_default: pinctrl-can0-default {
> > +               common {
> > +                       function = "can0";
> > +                       groups = "can0_9_grp";
> > +                       bias-pull-up = <0>;
> 
> No. If you want pull-up, just use
> bias-pull-up;
> 
> If you want to disable pull-up, use
> bias-disable;

But bias-disable also disables high-impedance. That doesn't work for me,
I think.

> 
> > +                       slew-rate = <0>;
> 
> If this measure is any kind of time unit, this is against the laws of nature.

It's not. As the bindings say, the argument is driver specific. In the
Zynq case you can simply choose fast or slow - whatever that means -
which maps to 0 or 1 in the DT. This though raises the question where
that documentation lives. Since this is a driver specific
interpretation, it should not be in the binding docs, IMHO. So, some
other place might need to be found to document the implementation
specifics.

> 
> > +                       io-standard = <1>;
> > +               };
> > +
> > +               rx {
> > +                       pins = "MIO46";
> > +                       bias-high-impedance = <1>;
> 
> Just
> bias-high-impedance;

Same problem as I have above. To allow all permutations of pull-up and
tri-state I can't just have a single disable-bias property.

> 
> > +               };
> > +
> > +               tx {
> > +                       pins = "MIO47";
> > +                       bias-high-impedance = <0>;
> 
> Just
> bias-disable;

That would also disable the pull-up.

	Sören
