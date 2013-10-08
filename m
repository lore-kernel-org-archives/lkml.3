Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3JHQVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:21:36 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46555 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3JHQVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:21:33 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/oMZ5wmLncV4JVPRGjpubK
Date: Tue, 8 Oct 2013 09:21:28 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 3/6] pinctrl: single: Prepare for supporting SoC
 specific features
Message-ID: <20131008162128.GB7773@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054218.8941.19273.stgit@localhost>
 <20131007173531.GX8949@atomide.com>
 <CACRpkdbx+vJEqz3KQ0EHGt0axRB4JeJh3FF4e+7snbR0HoqKRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbx+vJEqz3KQ0EHGt0axRB4JeJh3FF4e+7snbR0HoqKRg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [131008 05:03]:
> On Mon, Oct 7, 2013 at 7:35 PM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > Hi Linus W,
> >
> > Any comments on the pinctrl patches 3 - 5 in this series?
> 
> I have no problems with this patch #3, as it is just changing syntax,
> not semantics.
> 
> The problems start with patch #4.
> 
> I am tormented with mixed feelings about this, because from one point of
> view I feel it is breaking the promise of pinctrl-single being a
> driver for platforms
> where a pin is controlled by a *single* register.

It is still in that same *single* register. There are interrupt enable
and interrupt status bits for *every* pin register on most omaps.
 
> If this was pinctrl-foo.c I would not have been so much bothered,
> but now it is something that was supposed to be self-contained and
> simple, pertaining to a single register, starting to look like something
> else.
>
> This is a bit like: "oh yeah just one register controls the pins, but under
> some circumstances I also want to mess with this register over here,
> and then this register over there ..." etc.

Not true. If it was some other register I would have set it up as
a separate driver under drivers/irqchip.
 
> I'd like Haojian to ACK this to proceed since he's also using this driver
> now. Then I feel better on continuing down this road ...
> 
> Then I have a lesser comment on patch #4 since it makes it possible
> for this pin controller to support wake-up interrupt, as I don't see how
> this plays out with front-end GPIO controllers, but let's discuss that
> in the context of that patch.

It's completely separate from the GPIO controller wake-up events.

Regards,

Tony

