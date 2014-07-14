Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbaGNPBZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:01:25 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:57817 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbaGNPBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:01:15 -0400
Message-ID: <1405350049.13503.35.camel@iivanov-dev>
Subject: Re: [PATCH 0/4] New Qualcomm PMIC pin controller drivers
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Mon, 14 Jul 2014 18:00:49 +0300
In-Reply-To: <CAJAp7OgR7xc=LSf9tj+XQY1Nk=dQxCxTZ6HBEdf0NsriDZF85g@mail.gmail.com>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
	 <CACRpkdYcoA-nifxojO5tZUy6dL6P2PTSGW0mVLUfqG20rOg-Nw@mail.gmail.com>
	 <1404904380.16296.17.camel@iivanov-dev>
	 <CACRpkdb25foEcNroqLyZbX93FxqAZ7=2pGo6GPWP8YdrjUS8gg@mail.gmail.com>
	 <CAJAp7Og0Cr3oY=XpT4NzKUWykxkRTq1ZRDyamW6tgohfBs3dmg@mail.gmail.com>
	 <1404999558.16296.31.camel@iivanov-dev>
	 <CAJAp7OgR7xc=LSf9tj+XQY1Nk=dQxCxTZ6HBEdf0NsriDZF85g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-12 at 16:51 -0700, Bjorn Andersson wrote:
> On Thu, Jul 10, 2014 at 6:39 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> > On Wed, 2014-07-09 at 07:02 -0700, Bjorn Andersson wrote:
> [..]
> >> Correct Ivan; we do however share the same issues related to how to do
> >> interrupt handling,
> >
> > Yep, but do we actually need to do interrupt handling in driver?
> > Interrupts are handled by parent device. GPIO client drivers could
> > use interrupt-controller registered by core driver?
> >
> 
> Among other things we have the volume and camera keys hooked to these
> pins, using the gpio-keys driver; so that needs to be able to convert
> a gpio to an irq.
> But I don't believe we should turn this driver into an
> interrupt-controller; as that wouldn't add any value...

I agree. But I would like to avoid specifying 44 "interrupts" in
DT files if they are known a priory in driver for specific chip.

Only drawback that I could see is that it will be little odd for
client drivers, which are using SPMI PMIC pinctrl driver, to specify
4 parameters required by interrupts property.

Regards,
Ivan

