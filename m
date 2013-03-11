Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3CKWBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:01:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:38431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3CKWBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,825,1355126400"; 
   d="scan'208";a="299469948"
Date: Mon, 11 Mar 2013 22:00:59 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        jln@google.com, marcheu@chromium.org
Subject: Re: [PATCH v2] drm/i915: bounds check execbuffer relocation count
Message-ID: <20130311220059.GA18499@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	jln@google.com, marcheu@chromium.org
References: <20130311212329.GA21629@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311212329.GA21629@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 02:23:29PM -0700, Kees Cook wrote:
> It is possible to wrap the counter used to allocate the buffer for
> relocation copies. This could lead to heap writing overflows.

I'd keep the return value as EINVAL so that we can continue to
distinguish between the user passing garbage and hitting an oom. And
total_relocs is preferrable to total, which also leads us to think more
carefully about the error condition. I think the check should be against
INT_MAX / sizeof(struct reloc_entry) for consistency with our other
guard against overflows whilst allocating.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
