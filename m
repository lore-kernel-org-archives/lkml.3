Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3CKUxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:53:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:58258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043Ab3CKUw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,825,1355126400"; 
   d="scan'208";a="300274032"
Date: Mon, 11 Mar 2013 20:52:51 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: bounds check execbuffer relocations
Message-ID: <20130311205251.GB31324@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
References: <20130311192716.GA18244@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311192716.GA18244@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:27:16PM -0700, Kees Cook wrote:
> It is possible to wrap the counter used to allocate the buffer for
> relocation copies. This could lead to heap writing overflows.

Seems a sensible check, just in the wrong location. You need to do the
checking upfront in validate_exec_list() so that the error condition is
always hit and that the limits are applied consistently to all
execbuffers.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
