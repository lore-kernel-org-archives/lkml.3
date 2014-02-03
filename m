Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaBCS7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:59:43 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2906 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaBCS7k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:59:40 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 03 Feb 2014 10:58:16 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Mark Rutland <mark.rutland@arm.com>
CC: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 3 Feb 2014 10:59:38 -0800
Subject: RE: [PATCH v1] ARM: tegra: add nvidia,wdt-timer-id optional property
Thread-Topic: [PATCH v1] ARM: tegra: add nvidia,wdt-timer-id optional
 property
Thread-Index: Ac8hAuoiUK0kqejmRAOGd7y1YQMzDgADpbGQ
Message-ID: <643E69AA4436674C8F39DCC2C05F763863199852CA@HQMAIL03.nvidia.com>
References: <1391204811-6293-1-git-send-email-achew@nvidia.com>
 <20140203171053.GA28338@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140203171053.GA28338@e106331-lin.cambridge.arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jan 31, 2014 at 09:46:51PM +0000, Andrew Chew wrote:
> > This optional property can be used to specify which timers are to be
> > used for hardware watchdog timeouts (via a tegra wdt driver).
> 
> Is there any reason that a particular timer should be used?

I worry about colliding with other timer allocations, and wanted to be
flexible in this regard.

> This shouldn't even mention the driver, as the binding should describe the
> HW, not how it's used by Linux at the moment.
> 
> >
> > Signed-off-by: Andrew Chew <achew@nvidia.com>
> > ---
> >  Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt | 8
> > ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git
> > a/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
> > b/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
> > index b5082a1..e87fa70 100644
> > --- a/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
> > +++ b/Documentation/devicetree/bindings/timer/nvidia,tegra30-timer.txt
> > @@ -13,6 +13,13 @@ Required properties:
> >  - clocks : Must contain one entry, for the module clock.
> >    See ../clocks/clock-bindings.txt for details.
> >
> > +Optional properties:
> > +
> > +- nvidia,wdt-timer-id: A list of timer IDs to be used for watchdogs.
> > +    Watchdog 0 will be assigned to the first timer listed, watchdog 1 will
> > +    be assigned to the second timer listed, etc. up to the number of
> watchdogs
> > +    available.
> 
> This sounds like a description of what software should do. Is there any
> reason this order is important?

The order in regards to which watchdog (watchdog 0, watchdog 1, etc) is paired
with which timer is unimportant for purposes of the watchdog driver that
I will follow up with.  I can leave those details out of the bindings description
if that resolves your concern.

> Also, it feels odd for the proerty name to be singular given it's a list...

You're right.  Given what it is, it really should be nvidia,wdt-timer-ids.

