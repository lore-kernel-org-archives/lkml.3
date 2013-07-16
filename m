Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3GPIbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:31:55 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:50596 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753130Ab3GPIbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:31:51 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Tue, 16 Jul 2013 09:31:40 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm/i915: fix long-standing SNB regression in power
 consumption after resume
Message-ID: <20130716083140.GK2823@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	David Airlie <airlied@linux.ie>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>
References: <20130714163009.22374.22100.stgit@zurg>
 <CAKMK7uEtReZxvzJj9LsSXEJEBNiK492CCONdsF5VFK2cA3u0FA@mail.gmail.com>
 <51E2E65D.5050803@openvz.org>
 <20130716063101.GK5784@phenom.ffwll.local>
 <CALYGNiOtt7FUCTqcyBELoHYEVw_zqmA=bpmHy_nDkhXCduB9qg@mail.gmail.com>
 <20130716074458.GM5784@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716074458.GM5784@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 09:44:59AM +0200, Daniel Vetter wrote:
> The issue I have with the current patch is that it looks a bit like
> duct-tape since the point where we drop the forcewake references seems to
> lack justification. The write to MBCTL itself will temporarily wake up the
> chip, so just wrapping that up in with forcewake is very likely not good
> enough. So I fear that we'll only hold forcewake long enough on most
> systems and still have a bunch of oddball broken systems out there.
> 
> Holding forcewake otoh until we've fully set up rps/rc6 makes imo tons of
> sense, hence why I've brought up the idea. Same reasoning applies to
> extending the w/a to all systems supporting rc6.

In which case disable rc6 at the start of init gating and only enable it
at the end of the deferred task. That I think will better test your
hypothesis and make the transistion steps clearer.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
