Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab3KQS31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 13:29:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50298 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3KQS3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 13:29:01 -0500
Date: Sun, 17 Nov 2013 19:28:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 4/5 v2] input: tc3589x-keypad: support probing from
 device tree
Message-ID: <20131117182845.GB30012@xo-6d-61-c0.localdomain>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
 <20131112153057.GA9683@earth.universe>
 <CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
 <20131112200514.GA15413@earth.universe>
 <CACRpkdaAaLjm_b+OLj3tobxBN8YGUcTPnXJ=qtBqd02=FTxhjQ@mail.gmail.com>
 <20131112204013.GA17674@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112204013.GA17674@earth.universe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I could find two boards using "gpio-matrix-keypad" in the mainline
> > > kernel and not a single instance of "linux,no-autorepeat":
> > 
> > In things connected to GPIO, I don't expect the in-kernel
> > device trees to be a good way so survey the usage of these
> > bindings. Anyone doing device trees on any system with a
> > few GPIOs can be using this.
> > 
> > But maybe we're lucky and won't break anyone's setup if
> > we change this?
> 
> AFAIK Device Tree property names are considered as ABI, so existing
> property names must not be removed.
> 
> But I guess we can add the standardized property name in addition
> to the deprecated one. New drivers can use the standardized property
> name from the beginning.
> 
> Thus I guess we should not use the name, which has the most adopters
> in kernel (or out of kernel). Instead the most fitting name should
> be used. Current suggestions (taken from kernel) are:
> 
> * <<vendor>>,no-autorepeat
> * keypad,autorepeat
> * linux,keypad-no-autorepeat
> * linux,input-no-autorepeat
> * linux,no-autorepeat
> * autorepeat
> 
> I do not really care, which one is chosen, except for two things:
> 
> * <<vendor>> seems wrong. This is not vendor specific.
> * I would prefer "input-" over "keypad-", since then the same name
>   can be used for single keys, buttons, etc.

Hmm, and it is not Linux-specific, either. So can we stick with simple "autorepeat"?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
