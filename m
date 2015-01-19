Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbbASQkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:40:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:39730 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbbASQkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:40:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,428,1418112000"; 
   d="scan'208";a="653237578"
Date: Mon, 19 Jan 2015 08:40:24 -0800
From: Matt Roper <matthew.d.roper@intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Jeremiah Mahler <jmmahler@gmail.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Ander Conselvan de Oliveira <conselvan2@gmail.com>,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [BUG, bisect] drm/i915: mouse pointer lags and
 overshoots
Message-ID: <20150119164024.GI22549@intel.com>
References: <20150117100635.GA1281@hudson.localdomain>
 <20150119090847.GQ10649@intel.com>
 <54BCE1BF.5050808@intel.com>
 <20150119110404.GA26577@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150119110404.GA26577@nuc-i3427.alporthouse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 11:04:04AM +0000, Chris Wilson wrote:
> On Mon, Jan 19, 2015 at 11:51:43AM +0100, Daniel Vetter wrote:
> > There's also an issue in (most) X drivers which exaberates this
> > issues: When changing the cursor buffer the X cursor code does a a)
> > disable cursor b) update cursor image c) enable cursor cycle.
> 
> Notably not -intel on which the bug has been observed. And more
> importantly, the slow downs don't seem to correlate with cursor change,
> just cursor movement.
> -Chris
> 
> -- 
> Chris Wilson, Intel Open Source Technology Centre

It seems that the simple fix for this case (movement only) is to just
skip the prepare_fb/cleanup_fb calls (and the associated vblank wait) in
the transitional plane helper when newfb == oldfb.  I just posted a
small patch that makes that change (and solves the cursor lag for me).

This won't solve the case if userspace uses a different framebuffer for
each update (while trying to update faster than the refresh rate).  Is
there any existing userspace that behaves this way that we can test
with?


Matt

-- 
Matt Roper
Graphics Software Engineer
IoTG Platform Enabling & Development
Intel Corporation
(916) 356-2795
