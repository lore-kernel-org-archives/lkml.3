Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3C1W3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 18:29:22 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:51099 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab3C1W3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 18:29:20 -0400
X-IronPort-AV: E=Sophos;i="4.87,369,1363129200"; 
   d="scan'208";a="10924405"
Date: Thu, 28 Mar 2013 23:29:17 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: Julia Lawall <julia.lawall@lip6.fr>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        florianschandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "backports@vger.kernel.org" <backports@vger.kernel.org>,
        cocci@systeme.lip6.fr,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rodrigo.vivi" <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "rafael.j.wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH] compat/compat-drivers/linux-next: fb skip_vt_switch
In-Reply-To: <CAB=NE6VPRu8DvneVdwd=pXF0ngi5OifNTpZtX3pLi50i116_OA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1303282328200.2022@localhost6.localdomain6>
References: <1364472270-9297-1-git-send-email-mcgrof@do-not-panic.com> <20130328083943.01e61b4b@jbarnes-desktop> <alpine.DEB.2.02.1303281718490.1928@hadrien> <CAB=NE6WbNwPqEPYsASAPaECe4qbAWdd4=eJ402ib+CzZbT69=g@mail.gmail.com> <alpine.DEB.2.02.1303281909570.1928@hadrien>
 <CAB=NE6VPRu8DvneVdwd=pXF0ngi5OifNTpZtX3pLi50i116_OA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Luis R. Rodriguez wrote:

> On Thu, Mar 28, 2013 at 11:10 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> > On Thu, 28 Mar 2013, Luis R. Rodriguez wrote:
> >>
> >> Thanks Julia! I'll be sure to try to add this to compat-drivers if the
> >> upstream fb patch is not accepted. If it is accepted we would not need
> >> this at all!
> >>
> >> > Then I guess there would be a similar rule for the false case?
> >>
> >> Nope, see that's the proactive strategy taken by the static inline and
> >> hence the patch. compat would have a static inline for both cases, and
> >> for the false case it'd be a no-op. If accepted upstream though then
> >> we would not need any changes for this collateral evolution. However
> >> *spotting* these collateral evolutions and giving you SmPL for them as
> >> a proactive strategy might be good given that if these type of patches
> >> are indeed welcomed upstream we'd then be able to address these as
> >> secondary steps. If they are not accepted then indeed we'd use them to
> >> backport that collateral evolution through both compat (adds the
> >> static inlines) and compat-drivers (the SmPL).
> >
> > Probably I am missing something, since I haven't looked at the code in
> > detail, bu wouldn't it be nicer to have a function call for the false
> > case, if there is a function call for the true case?
> 
> Yes, and indeed we have that, its the same function call, in the
> negative case its a no-op, in the newer kernels it wraps to modifying
> the element as in the original code.
> 
> > In looking at the
> > code, one could wonder why things are not done in a parallel way.
> 
> Not sure I get this.

I looked in today's linux-next, and there seems to be only one 
initialization of this field, to true, and one test of this field.  So 
perhaps the case for setting the field to false just isn't needed.

julia
