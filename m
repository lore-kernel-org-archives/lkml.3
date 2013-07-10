Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3GJUgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:36:31 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:44662 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3GJUg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:36:29 -0400
MIME-Version: 1.0
In-Reply-To: <51CC45D3.2000305@ti.com>
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
	<CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com>
	<20130625065811.GZ5523@atomide.com>
	<51CAEA90.90200@ti.com>
	<CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com>
	<51CC45D3.2000305@ti.com>
Date: Wed, 10 Jul 2013 22:36:28 +0200
Message-ID: <CACRpkdYU13bhPaL2ZG9CT9JRv9sKQ+1N3zCUPizk571+LQqB4A@mail.gmail.com>
Subject: Re: [RFC] ARM: OMAP2+: omap_device: add pinctrl handling
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@linaro.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 4:01 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> I think, In the future the OMAP pinctrl configurations would be manged in
> more flexible way then now (thanks to "pinctrl PM helpers" and you;))
> - "Idle" state will be splitted to "Idle"/"sleep"
> - "default" state will be splitted to "default"/"active"

OK so the first ones we already have so the discussion is now down
to adding the "active" state (and pinctrl_pm* helper function).

I guess we need a patch set prepared which adds the "active" state
and helper function as the first patch, i.e. this:
http://marc.info/?l=linux-kernel&m=137094012703340&w=2
Can I have your ACK on this patch?

I do not want to add the state unless there is a clear consumer,
so it needs to go in with the first patch to a device driver that uses
pinctrl_pm_select_active_state() which will be a good demonstration
on its use and utility. (And a point to object and suggest other ways
to do the same thing...)

Yours,
Linus Walleij
