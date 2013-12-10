Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab3LJAaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:30:22 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:6037 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751061Ab3LJAaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:30:20 -0500
Date: Tue, 10 Dec 2013 00:27:01 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/3] pinctrl: Add msm8x74 configuration
Message-ID: <20131210082700.GE11990@sonymobile.com>
References: <1386295805-13708-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1386295805-13708-3-git-send-email-bjorn.andersson@sonymobile.com>
 <52A24E08.706@codeaurora.org>
 <CACRpkdb+9DE6WNfBSp9Y8ErhHjaE-PdezJbYvsLLhiCjXfmA-A@mail.gmail.com>
 <52A63829.10509@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <52A63829.10509@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 09 Dec 13:37 PST 2013, Stephen Boyd wrote:

> On 12/09/13 00:18, Linus Walleij wrote:
> > On Fri, Dec 6, 2013 at 11:22 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> >> On 12/05/13 18:10, Bjorn Andersson wrote:
> > As the driver is merged I expect fixes to come in as additional patches.
> >
> >>> Add initial definition of parameters for pinctrl-msm for the msm8x74
> >>> platform.
> >> Hmm. We've tried to remove 'x' from our code because it isn't really
> >> accurate and leads to more confusion.
> > So does this pin controller have a real name in the data sheet?
> 
> We call it TLMM (top-level mode mux). So far there have been three major
> revisions of the hardware and 8974 uses the latest version.
> 

The pinctrl-msm.c driver would be the TLMM (v2 and v3) driver...

> >
> > I usually prefer to name the drivers after the name of the IP
> > block rather than the SoC if possible.
> >
> > Or should it just be named pinctrl-msm.c?
> 
> Leaving the pinctrl-msm.c file as in these patches is fine. For the SoC
> specific data files we should use the base chip name which in this case
> is 8974. I suppose the goal of pinctrl-msm8x74.c is to support 8974 and
> 8074 SoCs in the same file because they're almost exactly the same minus
> some pins losing their "modem" functions. Given that, the file names are
> fine but the binding and the data structures should be specific about
> which SoC we're talking about.

...and the pinctrl-msm8x74.c would be the data for SoCs matching that name.

Currently we know that 8074 is a 8974 without modem and the document I have
describing this incarnation of the SoC describes 8274, 8674 and 8974.

So as Stephen suggest; we could keep the name pinctrl-msm8x74.c as is and
we change the compatible to be explicit about this is qcom,msm8974-pinctrl.

That would give us room to handle any differences between 8074 and 8974 within
this file.

What do you say? Should I prepare a patch for this?

Regards,
Bjorn

