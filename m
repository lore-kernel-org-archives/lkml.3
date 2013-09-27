Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3I0SBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:01:08 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39442 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3I0SBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:01:06 -0400
Date: Fri, 27 Sep 2013 11:01:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Henrik Rydberg <rydberg@euromail.se>, khali@linux-fr.org,
        lm-sensors@lm-sensors.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        bugzilla@colorremedies.com
Subject: Re: applesmc oops in 3.10/3.11
Message-ID: <20130927180101.GA2087@roeck-us.net>
References: <CA+5PVA5mmLPEqM2r5=fBN4sM4LLacynn8R1tewObsX35e4_TfA@mail.gmail.com>
 <20130925195628.GA1532@roeck-us.net>
 <20130925214807.GA3234@polaris.bitmath.org>
 <20130925220838.GB4184@roeck-us.net>
 <20130926063453.GA526@polaris.bitmath.org>
 <CA+5PVA76tjoR+GNaQps_zQmqz=V_GAcQaZLqKcx1ihgUMQBrQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA76tjoR+GNaQps_zQmqz=V_GAcQaZLqKcx1ihgUMQBrQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:21:04PM -0400, Josh Boyer wrote:
> On Thu, Sep 26, 2013 at 2:34 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> >> > > This suggests that initialization may be attempted more than once. The key cache
> >> > > is allocated only once, but the number of keys is read for each attempt.
> >> > >
> >> > > No idea if that can happen, but if the number of keys can increase after
> >> > > the first initialization attempt you would have an explanation for the crash.
> >> >
> >> > Good idea, and easy enough to test with the patch below.
> >> >
> >> Should we apply this patch even though it may not solve the specific problem ?
> >
> > Yes, why not - it certainly won't hurt. I am running it right now, so
> > it is at least run-tested.
> >
> >> Again, not sure if the key count can change, but the current code is at the very
> >> least inconsistent, as it keeps reading the key count without updating or
> >> verifying the cache size.
> >
> > Yes - I agree that the error state is far-fetched, but it is hard to
> > see any other logical explanation. There is of course always the
> > possibility that the problem is somewhere else completely.
> >
> > Proper patch attached.
> >
> > Thanks,
> > Henrik
> >
> > ---
> >
> > From dedefba9167913c46e1896ce0624e68ffe95d532 Mon Sep 17 00:00:00 2001
> > From: Henrik Rydberg <rydberg@euromail.se>
> > Date: Thu, 26 Sep 2013 08:33:16 +0200
> > Subject: [PATCH] hwmon: (applesmc) Check key count before proceeding
> >
> > After reports from Chris and Josh Boyer of a rare crash in applesmc,
> > Guenter pointed at the initialization problem fixed below. The patch
> > has not been verified to fix the crash, but should be applied
> > regardless.
> >
> > Reported-by: <jwboyer@fedoraproject.org>
> > Suggested-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> > ---
> >  drivers/hwmon/applesmc.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> Thanks for the quick reply.  I'll get this rolled into our kernels soon.
> 
Patch is now upstream (commit 5f4513864).

Guenter
