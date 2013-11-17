Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab3KQS3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 13:29:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50311 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3KQS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 13:29:08 -0500
Date: Sun, 17 Nov 2013 19:28:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/5 v2] input: tc3589x-keypad: support probing from
 device tree
Message-ID: <20131117182852.GC30012@xo-6d-61-c0.localdomain>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
 <20131112153057.GA9683@earth.universe>
 <CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
 <20131112200514.GA15413@earth.universe>
 <CACRpkdaAaLjm_b+OLj3tobxBN8YGUcTPnXJ=qtBqd02=FTxhjQ@mail.gmail.com>
 <20131112204013.GA17674@earth.universe>
 <20131113142406.GH21713@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113142406.GH21713@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Thus I guess we should not use the name, which has the most adopters
> > in kernel (or out of kernel). Instead the most fitting name should
> > be used. Current suggestions (taken from kernel) are:
> > 
> > * <<vendor>>,no-autorepeat
> > * keypad,autorepeat
> > * linux,keypad-no-autorepeat
> > * linux,input-no-autorepeat
> > * linux,no-autorepeat
> > * autorepeat
> > 
> > I do not really care, which one is chosen, except for two things:
> > 
> > * <<vendor>> seems wrong. This is not vendor specific.
> > * I would prefer "input-" over "keypad-", since then the same name
> >   can be used for single keys, buttons, etc.
> 
> Both of those sound valid to me, but I think it may make sense to keep
> the "linux," prefix. As I understand it this is really telling the Linux
> input subsystem to react to a device acting in a certain way, rather
> than describing or configuring the device in a certain way.

I'd say it is very much configuring device in certain way, and yes, other
operating systems will want to do autorepeat, too.

I believe we don't want to end up with

linux,input-no-autorepeat
bsd,keypad-autorepeat
windows-phone,disable-autorepeat

...and should avoid linux, prefix.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
