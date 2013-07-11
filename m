Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3GKGSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 02:18:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23290 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009Ab3GKGSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 02:18:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX183L5xWbrpZJlHVwx5E7jCi
Date: Wed, 10 Jul 2013 23:17:58 -0700
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
Message-ID: <20130711061757.GX5523@atomide.com>
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
 <CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com>
 <20130625065811.GZ5523@atomide.com>
 <51CAEA90.90200@ti.com>
 <CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com>
 <51CC45D3.2000305@ti.com>
 <CACRpkdYU13bhPaL2ZG9CT9JRv9sKQ+1N3zCUPizk571+LQqB4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYU13bhPaL2ZG9CT9JRv9sKQ+1N3zCUPizk571+LQqB4A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [130710 13:42]:
> On Thu, Jun 27, 2013 at 4:01 PM, Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
> 
> > I think, In the future the OMAP pinctrl configurations would be manged in
> > more flexible way then now (thanks to "pinctrl PM helpers" and you;))
> > - "Idle" state will be splitted to "Idle"/"sleep"
> > - "default" state will be splitted to "default"/"active"
> 
> OK so the first ones we already have so the discussion is now down
> to adding the "active" state (and pinctrl_pm* helper function).

I think I have a patchset ready for pinctrl to allow multiple simulaneous
states as discussed, need to test it first though. Should be able to
post it on Friday hopefully.
 
> I guess we need a patch set prepared which adds the "active" state
> and helper function as the first patch, i.e. this:
> http://marc.info/?l=linux-kernel&m=137094012703340&w=2
> Can I have your ACK on this patch?

Hmm I have gone a bit further with the drivers/base/pinctrl.c in my
set where if active state is defined then sleep and idle states must
match active state for the pingroups to avoid constantly checking
those sets during runtime.

Then the pinctrl_pm_select_active_state() does not actually have
anything to do with PM in the rx/tx case, so we should rename that.

It's pretty close, but before we can apply that we need the changes
I have to allow multiple simultaneous states. I suggest wait just
few days on that patch.
 
> I do not want to add the state unless there is a clear consumer,
> so it needs to go in with the first patch to a device driver that uses
> pinctrl_pm_select_active_state() which will be a good demonstration
> on its use and utility. (And a point to object and suggest other ways
> to do the same thing...)

Right, we have quite a few consumers with omaps for that as am33xx
requires remuxing wake-up events for all drivers AFAIK. The MMC SDIO
pin remuxing is probably closest one ready.

Regards,

Tony
