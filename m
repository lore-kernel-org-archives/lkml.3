Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaIAWNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:13:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:42172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaIAWNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:13:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,445,1406617200"; 
   d="scan'208";a="566789979"
Date: Mon, 1 Sep 2014 23:13:44 +0100
From: Damien Lespiau <damien.lespiau@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Regression in drm-intel caused by d91a2cb8e510
Message-ID: <20140901221344.GA22902@strange.ger.corp.intel.com>
References: <Pine.LNX.4.44L0.1409011609390.13894-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1409011609390.13894-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 04:19:23PM -0400, Alan Stern wrote:
> Daniel:
> 
> I'm encountering a problem with the drm-intel-nightly branch in your
> drm-intel repository.  The symptom is that when I boot my laptop, at
> some point during the start-up procedure the screen goes totally blank,
> as though the backlight were turned off, and it remains that way.  I
> can't tell if the backlight really is off -- it may be that there's
> just nothing being displayed -- and playing with the screen-brightness
> function keys doesn't help.
> 
> Git bisect located the source of the problem as commit d91a2cb8e510
> (drm/i915: Add 180 degree primary plane rotation support).  The problem
> occurs when I boot a kernel built from that commit, and it doesn't
> occur when I boot a kernel built from the preceding commit
> (19ac737dc3c3).
> 
> If necessary, I can get debugging info by logging in over a network 
> connection.  Tell me what you need.

It seems like Ville and Mika already caught a similar bug today, could
you give Ville's patch a go (available on the intel-gfx):

  drm/i915: Don't call intel_plane_restore() when the prop value didn't change


Thanks,

-- 
Damien
