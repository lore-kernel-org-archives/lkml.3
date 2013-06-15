Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3FOXfZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 19:35:25 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38158 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3FOXfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 19:35:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: Re: [RFC] pinctrl: generic: Add DT bindings
Date: Sun, 16 Jun 2013 01:35:34 +0200
Message-ID: <1795038.rqcr6GWLdP@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <201306152216.14252.heiko@sntech.de>
References: <1370988237-30593-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CACRpkdaF7V3FGhNNj+N+Dc-NWhsfQ=bqh+ETx0wGBFbLmxfGTw@mail.gmail.com> <201306152216.14252.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On Saturday 15 June 2013 22:16:13 Heiko Stübner wrote:
> Am Samstag, 15. Juni 2013, 21:56:05 schrieb Linus Walleij:
> > On Fri, Jun 14, 2013 at 12:39 AM, Laurent Pinchart wrote:
> > >         mmcif_pins: mmcif {
> > >                 mux {
> > >                         renesas,groups = "mmc0_data8_0", "mmc0_ctrl_0";
> > >                         renesas,function = "mmc0";
> > >                 };
> > >                 cfg {
> > >                         renesas,groups = "mmc0_data8_0";
> > >                         renesas,pins = "PORT279";
> > >                         bias-pull-up = <1>;
> > 
> > If I understood your code correctly that last statement can *optionally*
> > 
> > be written like just:
> >  bias-pull-up;
> > 
> > Without the parameter?
> > 
> > I think that Heiko's implementation does this anyway.
> 
> Yep, with the fixes-series from yesterday the bias-pull-* now have a better
> default value of <1>.
> 
> so you can do
> 	bias-pull-up;
> which is then identical to the
> 	bias-pull-up = <1>;
> above (both are valid of course).

My patch used bias-pull-up = <1>; as the current version of Heiko's DT parser 
didn't support bias-pull-up; correctly at that time. It's fixed now, and my 
prefered is then bias-pull-up;.

> Disable would the be either
> 	bias-disable;
> or
> 	bias-pull-up = <0>;
> 
> A driver should probably handle both, as both are valid pinconf options or
> this.

I feel a bit uneasy about that. Do we really need to support two different 
ways to achieve the same result ?

-- 
Regards,

Laurent Pinchart

