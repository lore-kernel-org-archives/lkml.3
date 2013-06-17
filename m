Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3FQSGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:06:50 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30663 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752127Ab3FQSGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:06:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19a6D7KiTk6pYpwdTFjQTdj
Date: Mon, 17 Jun 2013 11:06:40 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] pinctrl: document the pinctrl PM states
Message-ID: <20130617180640.GV20992@atomide.com>
References: <1370980749-15383-1-git-send-email-linus.walleij@stericsson.com>
 <51BA1FE7.4000900@wwwdotorg.org>
 <CACRpkdZV7R3MgbuvEMhs24YYv2hK8Kt9Kjmv_cpRQQ1NYviDQg@mail.gmail.com>
 <51BB3A2C.608@wwwdotorg.org>
 <20130617072021.GB4465@atomide.com>
 <CACRpkdbZ6QCU1N_3no+rahjVFSUgYMrDqtXW=4AjaY4RhaF9Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbZ6QCU1N_3no+rahjVFSUgYMrDqtXW=4AjaY4RhaF9Zw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130617 09:02]:
> On Mon, Jun 17, 2013 at 9:20 AM, Tony Lindgren <tony@atomide.com> wrote:
> 
> > Maybe let's again try to first list all the known cases where we need to
> > do remuxing, and the pins we need to remux?
> 
> In the pinctrl documentation this is known as "runtime pinmuxing".
> This is not common, it is much more common to change
> pin config, i.e. all other electrical properties of the pins,
> at runtime. Especially when going to sleep or idle.
> 
> > Below are the pin remuxing cases I'm aware of:
> >
> > 1. Remux UART RX pin of a device for a wake-up event
> >
> > 2. Remux whatever device interrupt line to a GPIO input for wake-up
> >
> > 3. Remux audio jack between UART RX and TX to provide a debug console
> >
> > 4. Remux MMC CMD and DAT lines for sleep with pulls to avoid device
> >    from resetting with lines floating or to save power
> >
> > Please list any further use cases that I'm not familiar with. I'd like
> > to hear how messed up this remuxing business can get :)
> 
> We have a debug port that can be muxed out on the keypad(!)
> or the SD card, and some other variants...
> 
> Stephen added the I2C block switch thing that switch one
> and the same IP core between different sets of pins (IIRC).

Oh those are pretty messed up.. Probably the worst case I've
seen is the remuxing of two MMC slots for a singel MMC controller
on omap2420 over I2C bus..
 
> For runtime pin config I have many more examples, we
> change a lot of those to so-called "GPIO mode" (basically
> just turned into an input with wakeup,  or pulled to ground)
> at sleep.

Hmm to me "GPIO mode" sounds like routing the signal to a
completely different device, how is that not remuxing?

Regards,

Tony
