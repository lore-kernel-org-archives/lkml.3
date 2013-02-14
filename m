Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761490Ab3BNRmp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:42:45 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49222 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3BNRmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:42:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] driver core: add wait event for deferred probe
To: Arnd Bergmann <arnd@arndb.de>, Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        viro@zeniv.linux.org.uk, rusty@rustcorp.com.au, hpa@linux.intel.com,
        jim.cromie@gmail.com, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        broonie@opensource.wolfsonmicro.com,
        Patch Tracking <patches@linaro.org>
In-Reply-To: <201302141557.18308.arnd@arndb.de>
References: <1360429077-14616-1-git-send-email-haojian.zhuang@linaro.org> <20130213213624.079BA3E3557@localhost> <CAD6h2NT73-af1Hgx0hCBkg8z1hQukK0XPESvrEcrUFv_VKGWjA@mail.gmail.com> <201302141557.18308.arnd@arndb.de>
Date: Thu, 14 Feb 2013 17:42:40 +0000
Message-Id: <20130214174240.810203E12FB@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Feb 2013 15:57:18 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 14 February 2013, Haojian Zhuang wrote:
> > If you can change it into code in below, it could work. Otherwise, it
> > always fails.
> >         driver_deferred_probe_enable = true;
> >         driver_deferred_probe_trigger();
> > +      deferred_probe_work_func(NULL);
> >         return 0;
> > 
> > Because deferred_probe_work_func() depends on that deferred_probe is added
> > into deferred_probe_active_list. If driver_deferred_probe_trigger() isn't called
> > first, the deferred uart probe can't be added into active list. So even you call
> > work_func at here, it doesn't help.
> > 
> 
> Would that not cause two instances of the work function to run at the same time?
> That sounds like a source for a lot of problems.

Yes. Even ignoring the problems with device drivers not handling
multithreaded probing well, the current deferred probe wouldn't handle
it well. I could make it support multithreading, but I don't see a whole
lot of value there.

g.

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
