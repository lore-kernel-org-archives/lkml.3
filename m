Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab3GZH1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:27:09 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:62716 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753454Ab3GZH1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:27:06 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Fri, 26 Jul 2013 08:26:46 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-next <linux-next@vger.kernel.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
Message-ID: <20130726072646.GH13295@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI <dri-devel@lists.freedesktop.org>,
	linux-next <linux-next@vger.kernel.org>,
	"s.dilek" <s.dilek@jpberlin.de>
References: <CA+icZUVLXxA5LPxzTjyhP5gryNUH3OY+vutoXQj6ydtCU0msbA@mail.gmail.com>
 <20130725190006.GD11514@cantiga.alporthouse.com>
 <CA+icZUW6oLE6cdnCkekz+43SrUn=vThqdfSKzz=XP-vmvB7Amw@mail.gmail.com>
 <20130725192248.GA13295@cantiga.alporthouse.com>
 <CA+icZUVE3s=6vXTLsCSmdLe_HMTOj+VD317kDeH3tF7svVW8kQ@mail.gmail.com>
 <CA+icZUU__nxcuX4RF9EBGm0nMBFaxfWpH00b2=ZsZZaxo9iscw@mail.gmail.com>
 <20130725215259.GB13295@cantiga.alporthouse.com>
 <CA+icZUXZKndg7==Y6v2Z45WZDp+tDC5FzaOC=KWTf4m=rjUKnA@mail.gmail.com>
 <20130725232556.GF13295@cantiga.alporthouse.com>
 <CA+icZUUBhW=KnAt0yn3CgEAzUhOfE=1ADUbCshFqrdZ5urEgbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUBhW=KnAt0yn3CgEAzUhOfE=1ADUbCshFqrdZ5urEgbw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 09:15:14AM +0200, Sedat Dilek wrote:
> For example: I could start my X with even doing ugly hacks like this...
> 
> [ intel-ddx (git) ]
> ...
> Bool intel_uxa_create_screen_resources(ScreenPtr screen)
> ...
> #if 0
> 	if (drm_intel_gem_bo_map_gtt(bo))
> 		return FALSE;
> #endif
> ...
> 
> ...with any other kernel.

Yes. Acquiring the map there is just a bit of paranoia to ensure we
having the mapping into the scanout already in place in case of
emergencies (and so don't fail along failure paths due to resource
conflicts).

Hmm, though we only started checking for map failures in 2.20.10 - which
would explain why going back to the older ddx masks the issue. And yes,
this means we do require a kernel bisect - or some passing inspiron.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
