Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761305Ab3BLQAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:00:03 -0500
Received: from linux-sh.org ([111.68.239.195]:44679 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579Ab3BLQAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:00:00 -0500
Date: Wed, 13 Feb 2013 00:59:28 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 6/9] gpiolib: use descriptors internally
Message-ID: <20130212155927.GE6088@linux-sh.org>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
 <1359822572-26009-8-git-send-email-acourbot@nvidia.com>
 <CACRpkdbib-+pvMiLQN=f6d-1dhK2OK3znJeGoL7rDxDQYuJRuA@mail.gmail.com>
 <CAAVeFu+phNtzzj7rw96g9iH8sj9gGqd5SfAqtkDHvu3PeL_oQA@mail.gmail.com>
 <20130209091729.978C73E1A18@localhost>
 <CACRpkdagLssOG3FW8Qr1zqFabGMgdupADwg1=c0eQ7e76_XM5A@mail.gmail.com>
 <51192CC5.9060300@wwwdotorg.org>
 <CACRpkdaHuv7CXCy15-o94G0r0+2BStsi34ZVbBAhyGj=U3xgOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaHuv7CXCy15-o94G0r0+2BStsi34ZVbBAhyGj=U3xgOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 01:29:10PM +0100, Linus Walleij wrote:
> On Mon, Feb 11, 2013 at 6:39 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> > On 02/11/2013 07:09 AM, Linus Walleij wrote:
> 
> >> However if you take this all the way to the descriptor API
> >> it will make the consumer (driver) API for GPIO descriptors deviate
> >> from what is today used for clocks, regulators and pins.
> >>
> >> With all the resulting confusion for users.
> >> I've seen worse subsystem deviations though.
> >
> > Sorry I haven't looked at the specific APIs this discussion refers to,
> > but clients of the GPIO descriptor API are going to need to distinguish
> > "fail" from "deferred probe", so at least some initial get-like API will
> > need to pass back some error detail...
> 
> Right, so in some other patch I stated that this would lead
> to a GPIO descriptor fetch interface such as this:
> 
> int gpiod_get(struct gpiod_desc **gpiod, struct device *dev, const char *name);
> 
> Rather than the more established:
> 
> struct gpio_desc *gpiod_get(struct device *dev, const char *name);
> 
> And I'm worried about the lack of consistency.
> 
> While I do get the point... I chatted with Grant about it and
> I want to talk to some toolchain people about this to see if
> pointers containing potential error codes can somehow be
> "flagged" by the compiler so we can enforce error checking on
> them. (It may sound a bit utopic...)
> 
At the very least you can __must_check annotate, although that's probably
still a bit coarser grained than what you're after.
