Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3CRMtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 08:49:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:8995 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab3CRMtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 08:49:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="scan'208";a="281005826"
Date: Mon, 18 Mar 2013 12:48:41 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Shawn Starr <shawn.starr@rogers.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] drm/i915: Flush writes to GMBUS registers
Message-ID: <20130318124841.GA3995@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	Shawn Starr <shawn.starr@rogers.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>
References: <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
 <1363605185-4030-1-git-send-email-chris@chris-wilson.co.uk>
 <alpine.LNX.2.00.1303181251040.9529@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1303181251040.9529@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 12:51:45PM +0100, Jiri Kosina wrote:
> On Mon, 18 Mar 2013, Chris Wilson wrote:
> 
> > If we do not complete the writes to the GMBUS registers, they remain
> > active for an indefinite period of time afterwards, even causing
> > spurious interrupts on gm45.
> > 
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Link: http://lkml.kernel.org/r/alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz
> > Cc: Shawn Starr <shawn.starr@rogers.com>
> > Cc: Jiri Kosina <jkosina@suse.cz>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> 
> Unfortunately I can't provide my Tested-by or Acked-by for this, as I am 
> still seeing the "nobody cared" for irq 16 with this patch applied.

The message reappeared on the third reboot. Perhaps an indicator that it
is a timing issue. I guess the sensible approach then is to exclude gen4
from the whitelist for gmbus irqs.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
