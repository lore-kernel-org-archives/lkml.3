Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3FNGtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:49:04 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:57422
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab3FNGtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:49:02 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 14 Jun 2013 14:39:59 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: cfa10036: Add USB0 OTG port
Message-ID: <20130614063956.GA13600@S2101-09.ap.freescale.net>
References: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
 <1371131025-12200-2-git-send-email-maxime.ripard@free-electrons.com>
 <24013808.T2v7Fa5NMK@wuerfel>
 <20130614063051.GE20513@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130614063051.GE20513@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 02:30:53PM +0800, Shawn Guo wrote:
> On Fri, Jun 14, 2013 at 12:06:51AM +0200, Arnd Bergmann wrote:
> > On Thursday 13 June 2013 15:43:42 Maxime Ripard wrote:
> > > +
> > > +       ahb@80080000 {
> > > +               usb0: usb@80080000 {
> > > +                       pinctrl-names = "default";
> > > +                       pinctrl-0 = <&usb0_otg_cfa10036>;
> > > +                       status = "okay";
> > >                 };
> > >         };
> > > 
> > 
> > The patches all look good, just one trivial comment about the fragment above:
> > 
> > There is already a "usb0" label in the imx28.dtsi file for the same
> > node. When you refer to the node from a board.dts file, either leave
> > out the redundant label, or use it to simplify the statements above
> > to the brief version:
> > 
> > 	&usb0 {
> > 		pinctrl-names = "default";
> > 		pinctrl-0 = <&usb0_otg_cfa10036>;
> > 		status = "okay";
> > 	};
> 
> Yeah, I moved all imx board level dts files to use this.  But I was told
> by Olof that the change does not gain too much and looks like a churn.
> That's why I haven't made the same move for mxs.  So I will remove the
> redundant label when applying this patch.

I would have the label stay there, because I found it's there like a
comment telling the controller instance.

Shawn

