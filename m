Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3J3N7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:59:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38588 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab3J3N7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:59:04 -0400
Date: Wed, 30 Oct 2013 14:59:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Grant Likely <grant.likely@linaro.org>
Cc: linux-input@vger.kernel.org, "'Beno?t Cousson'" <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 1/3] Input: twl4030-keypad - add device tree support
Message-ID: <20131030135902.GA2656@amd.pavel.ucw.cz>
References: <1382446042-27099-1-git-send-email-sre@debian.org>
 <1382446042-27099-2-git-send-email-sre@debian.org>
 <20131027111715.GA2437@xo-6d-61-c0.localdomain>
 <20131027114026.GB14091@earth.universe>
 <20131027114753.GB14901@amd.pavel.ucw.cz>
 <20131030135307.D8CE1C402A0@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030135307.D8CE1C402A0@trevor.secretlab.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-10-30 06:53:07, Grant Likely wrote:
> On Sun, 27 Oct 2013 12:47:53 +0100, Pavel Machek <pavel@ucw.cz> wrote:
> > > > > +#if IS_ENABLED(CONFIG_OF)
> > > > I'm probably missing something here, but why not #ifdef CONFIG_OF?
> > > 
> > > I have been told for other drivers, that IS_ENABLED() is
> > > the prefered way to check for configuration these days.
> > 
> > CONFIG_OF can not be module, using IS_ENABLED() on it is just wrong.
> 
> That makes no sense. There is absolutely nothing wrong with using
> IS_ENABLED() for CONFIG_OF.

Besides being too long, confusing for a reader, and testing for an
option that can't exist?

include/linux/kconfig.h-/*
include/linux/kconfig.h: * IS_ENABLED(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y' or 'm',
include/linux/kconfig.h- * 0 otherwise.
include/linux/kconfig.h- *
include/linux/kconfig.h- */
include/linux/kconfig.h:#define IS_ENABLED(option) \
include/linux/kconfig.h-	(config_enabled(option) || config_enabled(option##_MODULE))
include/linux/kconfig.h-
include/linux/kconfig.h-/*
include/linux/kconfig.h- * IS_BUILTIN(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'y', 0
include/linux/kconfig.h- * otherwise. For boolean options, this is
equivalent to
include/linux/kconfig.h: * IS_ENABLED(CONFIG_FOO).
include/linux/kconfig.h- */
include/linux/kconfig.h-#define IS_BUILTIN(option) config_enabled(option)
include/linux/kconfig.h-

Oops. And I made a mistake of looking up config_enabled(). Obfuscated
C code contest.

Just use #ifdef CONFIG_foo.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
