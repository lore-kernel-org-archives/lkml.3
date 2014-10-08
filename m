Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaJHVa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:30:59 -0400
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:3403
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754189AbaJHVa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:30:58 -0400
Date: Wed, 8 Oct 2014 14:30:45 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [RFC] pinctrl driver for Zynq
References: <c2b9a1c1-d3b9-48c5-9c14-a4c3a95965fa@BN1AFFO11FD046.protection.gbl>
 <CACRpkdaZ2Yy7=CcOjnsQ0K7KYTN=wHaeZTDNxpvnf+axLLLJ_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaZ2Yy7=CcOjnsQ0K7KYTN=wHaeZTDNxpvnf+axLLLJ_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21004.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <b5dad4dd03004926a818446558bfdede@BY2FFO11FD018.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(189002)(377424004)(51704005)(199003)(377454003)(52604005)(53416004)(77096002)(106466001)(85852003)(92566001)(85202003)(50986999)(102836001)(85182001)(23676002)(87936001)(31966008)(107046002)(95666004)(86362001)(64706001)(85306004)(80022003)(46102003)(44976005)(108616004)(21056001)(120916001)(110136001)(76176999)(50466002)(74316001)(20776003)(4396001)(6806004)(99396003)(54356999)(76482002)(104016003)(47776003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB041;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB041;
X-Forefront-PRVS: 0358535363
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 01:05PM +0200, Linus Walleij wrote:
> On Wed, Sep 24, 2014 at 11:09 PM, Sören Brinkmann
[...]
> > +++ b/drivers/pinctrl/Kconfig
> > @@ -305,6 +305,14 @@ config PINCTRL_PALMAS
> >           open drain configuration for the Palmas series devices like
> >           TPS65913, TPS80036 etc.
> >
> > +config PINCTRL_ZYNQ
> > +       bool "Pinctrl driver for Xilinx Zynq"
> > +       depends on ARCH_ZYNQ
> > +       select PINMUX
> > +       select GENERIC_PINCONF
> 
> Thanks for using generic pinconf. But you haven't implemented
> it yet?!

Muxing uses the generic pinconf stuff to parse the DT. Even for muxing
only I need this, I think. That codes needs to change with your
proposed change to introduce the 'groups' property.

	Sören
