Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3FYPjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:39:23 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63178 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3FYPjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:39:19 -0400
MIME-Version: 1.0
In-Reply-To: <51C9A039.4090804@imgtec.com>
References: <201306251455.01540.heiko@sntech.de>
	<201306251456.36499.heiko@sntech.de>
	<51C99581.2010403@imgtec.com>
	<201306251521.55634.heiko@sntech.de>
	<51C99AB5.1080002@imgtec.com>
	<CACRpkdbdwvmBYFX=ppdM_RmGwyTcWVeTCMj60F4sh6YEVRE2Uw@mail.gmail.com>
	<51C9A039.4090804@imgtec.com>
Date: Tue, 25 Jun 2013 17:39:19 +0200
Message-ID: <CACRpkda--Thd9sop2FRUwTKiXnePNyg38ajxAZVvKkROrQsGkw@mail.gmail.com>
Subject: Re: [PATCH 3/4] pinctrl: remove slew-rate parameter from tz1090
From: Linus Walleij <linus.walleij@linaro.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 3:50 PM, James Hogan <james.hogan@imgtec.com> wrote:
> On 25/06/13 14:32, Linus Walleij wrote:

>> Patches adding it back in with SI measures will be welcomed!
>
> Okay.
>
> So the most descriptive documentation I can find for the slew rate in
> the TZ1090 pin config hardware is basically:
>
> 0: slow (half frequency)
> 1: fast
>
> Sounds like this pretty much precludes it from having a generic DT
> binding unless it can be mapped to some physical value, so I'll add a
> tz1090,slew-rate and use PIN_CONFIG_END+1 instead of PIN_CONFIG_SLEW_RATE.

Okay... ut the Nomadik pin controller incidentally have a
similar definition: NMK_GPIO_LOWEMI. By slashing the
slew rate in half the EMI is of course reduced so that was
another name for the same thing.

Maybe this is something that should just be boolean?

slewrate-reduced-slope;

?

> Anybody object to me adding an argument to
> pinconf_generic_parse_dt_config() so that an additional
> pinconf_generic_dt_params array can be optionally passed in? That way I
> can share the generic pinconf dt parsing code.

Hm hm hm, that sounds more like it could be a separate
utility function. Then it could help to parse any such array
of custom bindings.

Yours,
Linus Walleij
