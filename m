Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3LPQWC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:22:02 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:19187 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754101Ab3LPQV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:21:59 -0500
Date: Mon, 16 Dec 2013 16:18:43 -0800
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Christian Daudt <bcm@fixthebug.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Heiko St?bner <heiko@sntech.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Sherman Yin <syin@broadcom.com>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/6] pinctrl: Make PINCTRL selectable by
 defconfig/menuconfig
Message-ID: <20131217001842.GB3840@sonymobile.com>
References: <1381174108-25168-1-git-send-email-syin@broadcom.com>
 <1386787041-6035-1-git-send-email-syin@broadcom.com>
 <1386787041-6035-4-git-send-email-syin@broadcom.com>
 <CACRpkdauqYNiby-ta3c_he2ovG__0e6ubmzZ8Bx1cP_OzK4=LQ@mail.gmail.com>
 <CAEPRUYpsp_FVobY_DeEQU2+rCD7q7T=p7k++XvG-22x-OWHY8Q@mail.gmail.com>
 <CACRpkdY2BExGiL6HBg7zn_szJQMnSNsxOSuo7RyrRmrz=cVe2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdY2BExGiL6HBg7zn_szJQMnSNsxOSuo7RyrRmrz=cVe2A@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 16 Dec 02:01 PST 2013, Linus Walleij wrote:

> On Thu, Dec 12, 2013 at 10:35 PM, Christian Daudt <bcm@fixthebug.org> wrote:
> 
> >  I had requested this from Sherman. The reason is so that pinctrl can
> > be selectable through defconfig, instead of through SoC select
> > statements. And the reason for that is so that, in the future, some of
> > these can be switched into loadable modules (which can't be done from
> > Kconfig). This will become necessary with the move to multiplatform -
> > we won't be able to have everything static anymore.
> 
> Isn't it sufficient to make the pin controller entry tristate rather
> than bool?
> 
> And as mentioned elsewhere this does not at all solve the issue
> that we still need to have all basic IRQchips and timer drivers
> compiled into the kernel.

No matter how we build the individual pinctrl drivers we will always
need the pinctrl framework in a multi-soc zImage; so I can't see that
we gain anything from being able to compile PINCTRL as a module.

I don't like compiling the individual pinctrl drivers as modules, as
it leaves us with a waterfall of PROBE_DEFERRs.

Regards,
Bjorn

