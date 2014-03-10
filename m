Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaCJRD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:03:57 -0400
Received: from www.linutronix.de ([62.245.132.108]:51841 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbaCJRDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:03:55 -0400
Date: Mon, 10 Mar 2014 18:04:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Bolle <pebolle@tiscali.nl>
cc: Julian Wollrath <jwollrath@web.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND] Fast TSC calibration fails with v3.14-rc1 and later
In-Reply-To: <1394465314.12752.18.camel@x220>
Message-ID: <alpine.DEB.2.02.1403101757320.18573@ionos.tec.linutronix.de>
References: <20140310110410.5b2218f6@ilfaris>  <1394447253.2979.12.camel@x220>  <alpine.DEB.2.02.1403101504590.18573@ionos.tec.linutronix.de> <1394465314.12752.18.camel@x220>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2014, Paul Bolle wrote:

> On Mon, 2014-03-10 at 15:06 +0100, Thomas Gleixner wrote:
> > And how is this related to Julians observation, that fast calibration
> > works in 3.13, but stopped to work in 3.14-rc ?
> 
> In the rest of my message - which you didn't quote - I stated that "the
> error need not be v3.14-rc1 specific. But perhaps something changed in
> v3.14-rc1 that makes it easier to trigger that error. I haven't
> checked". (I didn't add that, in my experience, this message is not seen
> at every boot.) So I'm basically advising Julian to double check whether
> this is really a change in behavior between v3.13 and v3.14-rc1. But
> perhaps Julian already did.

Oh, yes.

> > on a Thinkpad x121e (AMD E-450 APU) with version 3.13.5 and earlier of
> > the kernel I get:
> > [...]
> > but starting with v3.14-rc1 the fast TSC calibration fails:

 
> And I'm also telling Julian that, as far as I can tell, there's no
> reason to print this message at KERN_ERR level because what subsequently
> will happen is that an alternative calibration strategy is tried. So a
> failure of fast TSC calibration is apparently not so severe. See

And that does exactly make the regression he's observing go
away?

We want to know why stuff which worked and actually should still work
suddenly fails. Sure, the machine boots and nothing explodes, but it's
still a regression.

> https://lkml.org/lkml/2012/9/24/221 . Is that analysis incorrect?

Kinda. But there is no reason for the fast calibration to fail except
BIOS induced SMI nonsense.

Thanks,

	tglx





