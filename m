Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab3C1SF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:05:29 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:52967 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3C1SFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:05:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1303281718490.1928@hadrien>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com>
 <20130328083943.01e61b4b@jbarnes-desktop> <alpine.DEB.2.02.1303281718490.1928@hadrien>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 28 Mar 2013 11:05:03 -0700
X-Google-Sender-Auth: JRXEQtHvVQJMU9rQnQmOihQjkSY
Message-ID: <CAB=NE6WbNwPqEPYsASAPaECe4qbAWdd4=eJ402ib+CzZbT69=g@mail.gmail.com>
Subject: Re: [PATCH] compat/compat-drivers/linux-next: fb skip_vt_switch
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        cocci@systeme.lip6.fr,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rodrigo.vivi@gmail.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        rafael.j.wysocki@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 9:19 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> On Thu, 28 Mar 2013, Jesse Barnes wrote:
>> >     -      info->skip_vt_switch = true;
>> >     +      fb_enable_skip_vt_switch(info);
>> >
>> > So we'd then have to just add this static inline change for each new driver...
>> > There may be a way to get SmPL to do this for us...
>
> @@
> type of info  *info;
> @@
>
> -      info->skip_vt_switch = true;
> +      fb_enable_skip_vt_switch(info);
>
> for whatever the type of info is.

Thanks Julia! I'll be sure to try to add this to compat-drivers if the
upstream fb patch is not accepted. If it is accepted we would not need
this at all!

> Then I guess there would be a similar rule for the false case?

Nope, see that's the proactive strategy taken by the static inline and
hence the patch. compat would have a static inline for both cases, and
for the false case it'd be a no-op. If accepted upstream though then
we would not need any changes for this collateral evolution. However
*spotting* these collateral evolutions and giving you SmPL for them as
a proactive strategy might be good given that if these type of patches
are indeed welcomed upstream we'd then be able to address these as
secondary steps. If they are not accepted then indeed we'd use them to
backport that collateral evolution through both compat (adds the
static inlines) and compat-drivers (the SmPL).

  Luis
