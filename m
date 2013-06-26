Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3FZTb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:31:27 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:44262 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FZTbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:31:23 -0400
MIME-Version: 1.0
In-Reply-To: <51CAEA90.90200@ti.com>
References: <1371826990-25820-1-git-send-email-grygorii.strashko@ti.com>
	<CACRpkdY=m1b9Lh27+wHP8FQ4SbVZKmAOCGhxe59aP+TcuR9QaA@mail.gmail.com>
	<20130625065811.GZ5523@atomide.com>
	<51CAEA90.90200@ti.com>
Date: Wed, 26 Jun 2013 21:31:22 +0200
Message-ID: <CACRpkdbKgEcfF67oO9HrczvDp4Po3Xt1hFajJ1vO8kEvsZH4jA@mail.gmail.com>
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

On Wed, Jun 26, 2013 at 3:20 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> The "Sleep" pinctrl state is optional - if "sleep" state isn't defined
> then "Idle" pinctrl state will be used during suspend.

Why? If we have a clear cut semantic that "idle" is for runtime
suspend, why should it be a fallback for suspend?

You do realize that can just be turned around (as common suspend
is more widely implemented than runtime suspend) so that we
could say that if "idle" does not exist, we go to "sleep" in
runtime suspend.

> So, final list of default pnctrl states may be defined as "default",
> "active", "idle", "sleep", "off":
> - "active", "idle", "sleep": will be handled by omap_device core
> - "default", "off": will be handled by driver itself (or Device core).

Currently the pinctrl system combines what is called "default"
and "active" into one, assuming that all devices shall come up
in the active state.

Also we haven't seen a device that need some "off" state that
is different from "sleep".

If you want to drive this state list home you have to give a
*real world example*.

I want to see a *real* example, for a device and it's pins,
that define totally different things for these states, as a
rationale.

Else we are just defining states to make nice figures or mental
maps and that is not helpful for drivers writers.

Yours,
Linus Walleij
