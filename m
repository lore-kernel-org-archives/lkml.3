Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3CKVNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:13:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:30667 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab3CKVNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:13:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,825,1355126400"; 
   d="scan'208";a="276712476"
Date: Mon, 11 Mar 2013 21:13:26 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: clarify reasoning for the access_ok call
Message-ID: <20130311211326.GC31324@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Kees Cook <keescook@chromium.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
References: <20130311192630.GA18227@www.outflux.net>
 <20130311205125.GA31324@cantiga.alporthouse.com>
 <CAGXu5j+v9ma5rwhtPqtJKzve5q5G_m9VQkAUqJ38VnDFPpvGYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+v9ma5rwhtPqtJKzve5q5G_m9VQkAUqJ38VnDFPpvGYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 02:04:51PM -0700, Kees Cook wrote:
> Probably not. It just seemed like the existing comment was
> insufficient after the removal of the redundant VERIFY_READ check that
> happened recently.

That's certainly true, the remaining comment is a little cryptic.
Something more like:

/* We need to check that we can read the entire relocation array, but
 * as we may need to update the presumed_offsets upon execution, we
 * need to check now for full write access.
 */
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
