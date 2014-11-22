Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaKVQGy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 11:06:54 -0500
Received: from mail-bn1bon0062.outbound.protection.outlook.com ([157.56.111.62]:64663
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbaKVQGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 11:06:53 -0500
Date: Sat, 22 Nov 2014 08:06:45 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [PATCH 3/7] pinctrl: pinconf-generic: Allow driver to specify DT
 params
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <1415041531-15520-4-git-send-email-soren.brinkmann@xilinx.com>
 <CACRpkdYfj2ydLQ4q_FKwXo73jzNsvj9u2Aem9EiuEw-OCvurrg@mail.gmail.com>
 <1416300621.30131.6.camel@mm-sol.com>
 <995406b8e0244c63a3ef8e58314e81f6@BL2FFO11FD037.protection.gbl>
 <1416383379.30131.14.camel@mm-sol.com>
 <84517404cda34124930ec838a639f538@BL2FFO11FD030.protection.gbl>
 <1416470777.28873.1.camel@mm-sol.com>
 <7e2f4984733343fdb4ea51cf7eb4c339@BY2FFO11FD046.protection.gbl>
 <1416555331.28873.8.camel@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416555331.28873.8.camel@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21122.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <0c3dad3ce852435fba127e8436f0e30f@BN1BFFO11FD047.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(51704005)(377424004)(189002)(164054003)(24454002)(199003)(77156002)(23676002)(33646002)(108616004)(4396001)(83506001)(120916001)(86362001)(107046002)(104016003)(6806004)(62966003)(110136001)(47776003)(20776003)(85202003)(76176999)(44976005)(50986999)(106466001)(92566001)(99396003)(102836001)(95666004)(77096003)(46102003)(85182001)(93886004)(50466002)(74316001)(54356999)(87936001)(31966008)(64706001)(21056001)(53416004)(561944003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB062;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB062;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB062;
X-Forefront-PRVS: 040359335D
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB062;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ivan,

On Fri, 2014-11-21 at 09:35AM +0200, Ivan T. Ivanov wrote:
> 
> On Thu, 2014-11-20 at 08:22 -0800, Sören Brinkmann wrote:
> > 
> > 
> > Also, I hope all my changes here don't break the current behavior. So,
> > those 27 driver should still be able to do what they currently do. But I
> > hope they could migrated over to use the generic bindings only in the
> > longer term, so that these custom properties disappear.
> > 
> > > > The pinctrl driver just assembles
> > > > some data structure that has the information regarding custom properties
> > > > and the core handles the rest.
> > > 
> > > Yup, that is nice. What will be really nice if it also handle custom,
> > > "function", "groups" and "pins" properties. Otherwise most of the drivers
> > > will not be able to benefit from this.
> > 
> > Why would you still need those? 
> 
> I don't need them :-). The point was that still majority of the drivers
> will have custom parsing functions. It would be nice if we could fix
> that too. I do understand that using custom "pins", "functions"... is
> something which is deprecated, but if core parsing functions allow
> passing custom strings for above purposes, in a similar way as your
> proposal, it will be easier for those drivers to migrate, I believe.

This does sound much more like a feature request than a fundamental
problem with the implementation, now. And like Laurent's feature
request, I'd like to turn this down. Otherwise this just gets hold up by
feature requests blocking pinctrl-zynq.
I think the interesting questions are:
1. Does it break any current user?
2. Is there anything fundamentally preventing adding your feature at
some later time as part of such a migration you describe?

	Thanks,
	Sören
