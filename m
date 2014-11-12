Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbaKLSxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:53:48 -0500
Received: from [207.46.100.65] ([207.46.100.65]:45386 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753100AbaKLSxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:53:46 -0500
Date: Wed, 12 Nov 2014 10:53:15 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 4/7] pinctrl: zynq: Document DT binding
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <1415041531-15520-5-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdazagbSZdMvHTggQuAFm9uObn2ARoCwcyM-sspuLTXqkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdazagbSZdMvHTggQuAFm9uObn2ARoCwcyM-sspuLTXqkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21096.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <682b075ae056422683f93be4ea892011@BL2FFO11FD024.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(377424004)(377454003)(164054003)(51704005)(24454002)(189002)(85202003)(47776003)(4396001)(50466002)(87936001)(6806004)(106466001)(120916001)(20776003)(102836001)(86362001)(46102003)(92566001)(21056001)(62966003)(108616004)(83506001)(77156002)(31966008)(104016003)(54356999)(74316001)(99396003)(23676002)(95666004)(53416004)(77096003)(110136001)(64706001)(19580395003)(85182001)(107046002)(76176999)(44976005)(50986999)(19580405001)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB066;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB066;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB066;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB066;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 04:00PM +0100, Linus Walleij wrote:
> On Mon, Nov 3, 2014 at 8:05 PM, Soren Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > Add documentation for the devicetree binding for the Zynq pincontroller.
> >
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> (...)
> > +Example:
> > +       pinctrl0: pinctrl@700 {
> > +               compatible = "xlnx,pinctrl-zynq";
> > +               reg = <0x700 0x200>;
> > +               syscon = <&slcr>;
> > +
> > +               pinctrl_uart1_default: pinctrl-uart1-default {
> > +                       common {
> > +                               groups = "uart1_10_grp";
> > +                               function = "uart1";
> > +                               slew-rate = <0>;
> > +                               io-standard = <1>;
> > +                       };
> 
> I don't really like that you mix multiplexing and config in the
> same node. I would prefer if the generic bindings say we have
> muxing nodes and config nodes, and those are disparate.
> 
> Can't you just split this:
> 
> common-mux {
>     groups = "uart1_10_grp";
>     function = "uart1";
> };
> 
> common-config {
>     groups = "uart1_10_grp";
>     slew-rate = <0>;
>     io-standard = <1>;
> };
> 
> That way we can identify nodes as mux nodes (have "function")
> or config nodes (have "groups" or "pins" but not "function") which
> I think makes things easier to read.

I think such separation is not required by the bindings currently and
the parser assumes everything can be present in any node.
Can we add that requirement to the generic bindings without breaking
current users? I think it would make the implementation a little easier.
	
	Thanks,
	Sören
