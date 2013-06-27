Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3F0HbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:31:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62007 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752488Ab3F0HbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:31:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+J+9OFMHp54zBOOVtJYJ2g
Date: Thu, 27 Jun 2013 00:30:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
Message-ID: <20130627073058.GF5523@atomide.com>
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
 <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com>
 <20130625065811.GZ5523@atomide.com>
 <51CAEA90.90200@ti.com>
 <CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130626 12:37]:
> On Wed, Jun 26, 2013 at 3:20 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> 
> > The "Sleep" pinctrl state is optional - if "sleep" state isn't defined
> > then "Idle" pinctrl state will be used during suspend.
> 
> Why? If we have a clear cut semantic that "idle" is for runtime
> suspend, why should it be a fallback for suspend?
> 
> You do realize that can just be turned around (as common suspend
> is more widely implemented than runtime suspend) so that we
> could say that if "idle" does not exist, we go to "sleep" in
> runtime suspend.
> 
> > So, final list of default pnctrl states may be defined as "default",
> > "active", "idle", "sleep", "off":
> > - "active", "idle", "sleep": will be handled by omap_device core
> > - "default", "off": will be handled by driver itself (or Device core).
> 
> Currently the pinctrl system combines what is called "default"
> and "active" into one, assuming that all devices shall come up
> in the active state.
> 
> Also we haven't seen a device that need some "off" state that
> is different from "sleep".

Right, this is what I've been wondering too.

Do we really need "idle", "sleep", "off"? Or is "idle" enough?
Or "idle" and "sleep"?

Only one of the should be set at a time, but it would be nice
to handle most cases in a generic way in drivers/base/pinctrl.c.
 
> If you want to drive this state list home you have to give a
> *real world example*.
> 
> I want to see a *real* example, for a device and it's pins,
> that define totally different things for these states, as a
> rationale.

Yeah me too :)
 
> Else we are just defining states to make nice figures or mental
> maps and that is not helpful for drivers writers.

Regards,

Tony
