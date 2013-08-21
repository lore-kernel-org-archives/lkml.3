Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3HUNVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:21:34 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:33759 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab3HUNVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:21:32 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.714
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2] RFC: interrupt consistency check for OF GPIO IRQs
Date: Wed, 21 Aug 2013 15:21:21 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        mark.rutland@arm.com, ian.campbell@citrix.com, galak@codeaurora.org,
        pawel.moll@arm.com
References: <1376387195-27469-1-git-send-email-larsi@wh2.tu-dresden.de> <9241298.URG9CVQFmF@flatron> <5212737A.1030904@wwwdotorg.org>
In-Reply-To: <5212737A.1030904@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308211521.21129.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 August 2013 at 21:35:22, Stephen Warren wrote:
> On 08/17/2013 03:59 AM, Tomasz Figa wrote:
> > [Ccing DT maintainers, as they may have some ideas as well]
> > 
> > On Saturday 17 of August 2013 02:16:11 Linus Walleij wrote:
> >> On Thu, Aug 15, 2013 at 11:53 AM, Tomasz Figa <tomasz.figa@gmail.com>  
wrote:
> ...
> 
> >>> This is the biggest problem of this patch. It assumes that there is
> >>> only a single and shared GPIO/interrupt specification scheme, which
> >>> might not be true.
> >>> 
> >>> First of all, almost all interrupt bindings have an extra,
> >>> semi-generic
> >>> flags field as last cell in the specifier. Now there can be more
> >>> than one>
> >>> 
> >>> cell used to index GPIOs and interrupts, for example:
> >>>         interrupts = <1 3 8>
> >>> 
> >>> which could mean: bank 1, pin 3, low level triggered.
> >> 
> >> You are right, but:
> >> Documentation/devicetree/bindings/interrupt-controller/interrupts.txt
> >> Specifies how to handle the one-celled and two-celled versions.
> >> 
> >> And nothing else is specified. So it's not overly complex.
> > 
> > The documentation states that:
> > 	It is the responsibility of the interrupt controller's binding to
> > 	define the length and format of the interrupt specifier.
> > 
> > Then two _example_ formats follow, preceded by following statement:
> > 	The following two variants are commonly used:
> > I already know a variant which uses three (Exynos combiner) and four
> > (S3C24xx interrupt controller) cells. They are not pin controllers,
> > but you can't stop anyone from adopting similar or even more complex
> > specifiers formats for their hardware, especially when it matches
> > more closely the interrupt/pin layout used in their hardware.
> 
> Yes, the binding doc interrupts.txt mentioned above does not specify
> *the* one-/two-cell format, but *a* common/possible one- and two-cell
> format. There's no strict reason that all interrupt controllers have to
> use those exact formats. The only way to parse interrupt specifiers is
> to ask the driver for the the interrupt controller code to parse the
> property.

I agree with you. I also understand the interrupts.txt binding doc as it 
lists only a common/possible cell format, but it's purpose is not to 
restrict it to this.

I send an updated patch, that uses the drivers xlate function to parse the 
interrupt property in a few minutes.

Thanks for clarifying this,
Lars
