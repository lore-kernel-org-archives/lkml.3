Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaICIJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:09:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562AbaICIJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:09:00 -0400
Date: Wed, 3 Sep 2014 10:08:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Daniel Vetter <daniel@ffwll.ch>
cc: Dave Airlie <airlied@gmail.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [drm/i915/3.17] panic in i915_digport_work_func
In-Reply-To: <20140901091440.GW15520@phenom.ffwll.local>
Message-ID: <alpine.LRH.2.00.1409031008390.9600@twin.jikos.cz>
References: <1409382202.5141.36.camel@marge.simpson.net> <1409486735.4991.19.camel@marge.simpson.net> <CAPM=9txZ5mS3u-7FrjCMF6T3sATfAU2Y+fpyXi-REPWXExBajA@mail.gmail.com> <20140901091440.GW15520@phenom.ffwll.local>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2014, Daniel Vetter wrote:

> > From d407c946fbf5c48f30160591f5bd71fbe158aeb4 Mon Sep 17 00:00:00 2001
> > From: Dave Airlie <airlied@redhat.com>
> > Date: Mon, 1 Sep 2014 16:58:12 +1000
> > Subject: [PATCH] drm/i915: handle G45/GM45 pulse detection connected state.
> > 
> > In the HPD pulse handler we check for long pulses if the port is actually
> > connected, however we do that for IBX, but we use the pulse handling code on
> > GM45 systems as well, so we need to use a diffent check.
> > 
> > This patch refactors the digital port connected check out of the g4x detection
> > path and reuses it in the hpd pulse path.
> > 
> > Should fix:
> > Message-ID: <1409382202.5141.36.camel@marge.simpson.net>
> > 
> > Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
> > Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I was just about to start bisecting, as my thinkpad x200s with Gen4 chip
wouldn't ocassionally boot with -rc3, but this patch seems to be the cure
for me as well.

FWIW

        Tested-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs

