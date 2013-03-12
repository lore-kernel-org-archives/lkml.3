Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3CLJHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:07:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:32483 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168Ab3CLJHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:07:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,829,1355126400"; 
   d="scan'208";a="300715833"
Date: Tue, 12 Mar 2013 09:07:46 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Julien Tinnes <jln@google.com>,
        marcheu@chromium.org
Subject: Re: [PATCH v3] drm/i915: bounds check execbuffer relocation count
Message-ID: <20130312090746.GD31324@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, Julien Tinnes <jln@google.com>,
	marcheu@chromium.org
References: <20130312003145.GA28993@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312003145.GA28993@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 05:31:45PM -0700, Kees Cook wrote:
> It is possible to wrap the counter used to allocate the buffer for
> relocation copies. This could lead to heap writing overflows.
> 
> CVE-2013-0913
> 
> v3: collapse test, improve comment
> v2: move check into validate_exec_list
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reported-by: Pinkie Pie
> Cc: stable@vger.kernel.org

Looks good to me. The only bikeshed that remains is whether we should
just collapse the two variables into one, but the current 'max - count'
is more idiomatic and so preferrable.
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
