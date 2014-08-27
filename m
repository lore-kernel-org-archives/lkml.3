Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbaH0SOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:14:21 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54630 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935516AbaH0SOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:14:18 -0400
Date: Wed, 27 Aug 2014 11:14:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: David Riley <davidriley@google.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Anton Vorontsov <anton@enomsg.org>,
        Marc Carino <marc.ceeeee@gmail.com>, Anders Berg <anders.berg@lsi.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jamie Lentin <jm@lentin.co.uk>, Doug Anderson <dianders@chromium.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v1 1/1] power: Add simple gpio-restart driver
Message-ID: <20140827181413.GA2198@roeck-us.net>
References: <1409096705-24290-1-git-send-email-davidriley@chromium.org>
 <1409096705-24290-2-git-send-email-davidriley@chromium.org>
 <20140827014300.GA29512@earth.universe>
 <CAASgrz3ArGUJnPVvBcm2Hm0gwcUPYt2504M3t-3M5=c2DmKotA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAASgrz3ArGUJnPVvBcm2Hm0gwcUPYt2504M3t-3M5=c2DmKotA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 10:56:20AM -0700, David Riley wrote:
> Hi Sebastian,
> 
> Thanks for the feedback.
> 
> On Tue, Aug 26, 2014 at 6:43 PM, Sebastian Reichel <sre@kernel.org> wrote:
> > Hi David,
> >
> > On Tue, Aug 26, 2014 at 04:45:05PM -0700, David Riley wrote:
> >> This driver registers a restart handler to set a GPIO line high/low
> >> to reset a board based on devicetree bindings.
> >
> > Driver looks fine to me. I have some comments about the
> > Documentation, though:
> >
> >> [...]
> >> diff --git a/Documentation/devicetree/bindings/gpio/gpio-restart.txt b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
> >> new file mode 100644
> >> index 0000000..7cd58788
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/gpio/gpio-restart.txt
> >> @@ -0,0 +1,48 @@
> >> +Driver a GPIO line that can be used to restart the system as a
> >> +restart handler.
> >
> > Please fix the Typo (first word).
> 
> Fixed.
> 
> >
> >> [...]
> >> +
> >> +The driver supports both level triggered and edge triggered power off.
> >> +At driver load time, the driver will request the given gpio line and
> >> +install a restart handler.
> >
> > The wording is too driver centric IMHO. You are supposed to document
> > the binding in a generic way. Maybe start with something like:
> >
> > "This binding supports level and edge triggered reset."
> >
> > (power off is the wrong word, since there is already gpio-poweroff).
> 
> I've cleaned this up for v2.
> 
> >> +If the optional properties 'input' is +not found, the GPIO line
> >> +will be driven in the inactive state. Otherwise its configured
> >> +as an input.
> >
> > What is this needed for?
> 
> This allows other hardware to be attached to the same line to reset
> the system.  Carried forward from the gpio-poweroff implementation I
> based this on.
> 
Maybe rephrase; the point isn't really that it is configured as input but
that it is an open source pin unless actively driven to reset the system.
That linux models the pin as input is really an implementation detail.

Thanks,
Guenter
