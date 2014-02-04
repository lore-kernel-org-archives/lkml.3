Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaBDSz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:55:29 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13552 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaBDSzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:55:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Feb 2014 10:53:57 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "abrestic@chromium.org" <abrestic@chromium.org>,
        "dgreid@chromium.org" <dgreid@chromium.org>,
        "katierh@chromium.org" <katierh@chromium.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Tue, 4 Feb 2014 10:55:22 -0800
Subject: RE: [PATCH v2 2/3] clocksource: tegra: Define timer bases in header
 file
Thread-Topic: [PATCH v2 2/3] clocksource: tegra: Define timer bases in
 header file
Thread-Index: Ac8hfmiQw88vqEJzTRadAXkeVQnaAwAWzs1Q
Message-ID: <643E69AA4436674C8F39DCC2C05F763863199855EA@HQMAIL03.nvidia.com>
References: <1391473055-3158-1-git-send-email-achew@nvidia.com>
 <1391473055-3158-3-git-send-email-achew@nvidia.com>
 <52F09CC8.80601@linaro.org>
In-Reply-To: <52F09CC8.80601@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s14Itauo021147

> From: Daniel Lezcano [mailto:daniel.lezcano@linaro.org]
> Sent: Monday, February 03, 2014 11:55 PM
> To: Andrew Chew; tglx@linutronix.de; swarren@wwwdotorg.org;
> thierry.reding@gmail.com; rob@landley.net; grant.likely@linaro.org;
> robh+dt@kernel.org; abrestic@chromium.org; dgreid@chromium.org;
> katierh@chromium.org
> Cc: linux-kernel@vger.kernel.org; linux-tegra@vger.kernel.org; linux-
> watchdog@vger.kernel.org; linux-doc@vger.kernel.org
> Subject: Re: [PATCH v2 2/3] clocksource: tegra: Define timer bases in header
> file
> 
> On 02/04/2014 01:17 AM, Andrew Chew wrote:
> > Added timers that are present in tegra30 and later, that are NOT in tegra20.
> >
> > Also, some of these timer bases are needed in the tegra watchdog
> > driver, so separate them out into a header file that both the
> > clocksource driver and the watchdog driver can share them.
> >
> > Signed-off-by: Andrew Chew <achew@nvidia.com>
> 
> When reading the patch 3/3, I don't see any define reused from this header
> except TEGRA30_TIMER_WDT_BASE which is only used for the watchdog.
> May be I missed something but I don't see any definition shared and thus I
> don't see the point of creating this header file.

I guess the point is to make other potential drivers that make use of the timer
registers aware that this particular timer (timer 5) is provisioned for the watchdog
driver.  Right now, you're right, there really isn't much that's shared...the only
thing really is the base address of timer 5 (and its associated ID)...the timer bases
are kind of all over the place, so it's not straightforward to calculate the ID from the
base address.

But I believe the thought at the time (from Stephen Warren's suggestion) is to have
a central place where this stuff is defined so that it's more clear what timers are
provisioned for what purposes.  It just happens that today, the only users of
the timers, other than clocksource, is watchdog, as far as I can tell.

> > +++ b/include/clocksource/tegra_timer.h
> > @@ -0,0 +1,43 @@
> > +/*
> > + * Copyright (C) 2010 Google, Inc.
> > + *
> > + * Author:
> > + *	Colin Cross <ccross@google.com>

The contents of this new header file are largely just a cut and paste of the corresponding
snippet in tegra20-timer.c, so I thought I'd carry over the license verbatim.  I didn't author
this really...I just moved it around.  What should I do instead?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
