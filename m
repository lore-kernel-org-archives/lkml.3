Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab3FNJS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:18:28 -0400
Received: from gloria.sntech.de ([95.129.55.99]:59249 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab3FNJS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:18:27 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/2] pinctrl: add function to parse generic pinconfig properties from a dt node
Date: Fri, 14 Jun 2013 11:18:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrice Chotard <patrice.chotard.st@gmail.com>
References: <201306102139.32444.heiko@sntech.de> <CACRpkdZavNX3jk4K5unEJCED4vTuZEUF=NC1naGOMyr54hXQKw@mail.gmail.com> <1862891.4yIecp615h@avalon>
In-Reply-To: <1862891.4yIecp615h@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201306141118.22663.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 14. Juni 2013, 01:53:49 schrieb Laurent Pinchart:
> Hi Linus,
> 
> On Thursday 13 June 2013 17:36:00 Linus Walleij wrote:
> > On Thu, Jun 13, 2013 at 5:23 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > >> Ok, I'll see that I get this fixed :-)
> > > 
> > > Hmm ... what is the meaning of the argument of bias-disable and
> > > bias-high- impedance, as the kernel-doc in pinconf-generic.h does not
> > > tell?
> > 
> > I think those arguments are N/A, ignored, doesn't matter.
> > If these options were typed, they would be bool.
> > 
> > Please improve documentation if you can... sorry for all the
> > rough edges.
> > 
> > > bias-bus-hold ignores its argument and we already clarified that the
> > > pull-* do have != 0 or 0 argument.
> > 
> > I think in the DT binding, both these forms:
> > 
> > bias-pull-up;
> > bias-pull-up = <150000>;
> > 
> > Should be allowed.
> > 
> > So when parsing, you first check if it exists, then if there
> > is an argument, if there is no value supplied, just set it
> > to 1, as that is clearly != 0...
> 
> What's the expected way to disable pull-ups in DT ? Should it be
> 'bias-pull-up = <0>;' or 'bias-disable;' ?

According to the kernedoc I think both are valid and should be handled. Using 
bias-disable is more descriptive but would also include disabling a "high-
impedance" or "bus-hold" bias (if supported by the hardware).

Personally, for my rockchip stuff I go with using the "bias-pull-pin-default" 
<-> "bias-disable".

