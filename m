Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3C1SKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:10:55 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:20256
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab3C1SKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:10:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,927,1363129200"; 
   d="scan'208";a="9094077"
Date: Thu, 28 Mar 2013 19:10:50 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, FlorianSchandinat@gmx.de,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        cocci@systeme.lip6.fr,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rodrigo.vivi@gmail.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        rafael.j.wysocki@intel.com
Subject: Re: [PATCH] compat/compat-drivers/linux-next: fb skip_vt_switch
In-Reply-To: <CAB=NE6WbNwPqEPYsASAPaECe4qbAWdd4=eJ402ib+CzZbT69=g@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1303281909570.1928@hadrien>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com> <20130328083943.01e61b4b@jbarnes-desktop> <alpine.DEB.2.02.1303281718490.1928@hadrien> <CAB=NE6WbNwPqEPYsASAPaECe4qbAWdd4=eJ402ib+CzZbT69=g@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 28 Mar 2013, Luis R. Rodriguez wrote:

> On Thu, Mar 28, 2013 at 9:19 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> > On Thu, 28 Mar 2013, Jesse Barnes wrote:
> >> >     -      info->skip_vt_switch = true;
> >> >     +      fb_enable_skip_vt_switch(info);
> >> >
> >> > So we'd then have to just add this static inline change for each new driver...
> >> > There may be a way to get SmPL to do this for us...
> >
> > @@
> > type of info  *info;
> > @@
> >
> > -      info->skip_vt_switch = true;
> > +      fb_enable_skip_vt_switch(info);
> >
> > for whatever the type of info is.
>
> Thanks Julia! I'll be sure to try to add this to compat-drivers if the
> upstream fb patch is not accepted. If it is accepted we would not need
> this at all!
>
> > Then I guess there would be a similar rule for the false case?
>
> Nope, see that's the proactive strategy taken by the static inline and
> hence the patch. compat would have a static inline for both cases, and
> for the false case it'd be a no-op. If accepted upstream though then
> we would not need any changes for this collateral evolution. However
> *spotting* these collateral evolutions and giving you SmPL for them as
> a proactive strategy might be good given that if these type of patches
> are indeed welcomed upstream we'd then be able to address these as
> secondary steps. If they are not accepted then indeed we'd use them to
> backport that collateral evolution through both compat (adds the
> static inlines) and compat-drivers (the SmPL).

Probably I am missing something, since I haven't looked at the code in
detail, bu wouldn't it be nicer to have a function call for the false
case, if there is a function call for the true case?  In looking at the
code, one could wonder why things are not done in a parallel way.

julia
