Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3CQVk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 17:40:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:6277 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418Ab3CQVk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 17:40:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,860,1355126400"; 
   d="scan'208";a="280778148"
Date: Sun, 17 Mar 2013 21:40:49 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ben Widawsky <ben@bwidawsk.net>, Tommi Rantala <tt.rantala@gmail.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Jones <davej@redhat.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Sanity check incoming ioctl data
 for a NULL pointer
Message-ID: <20130317214049.GB26102@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Widawsky <ben@bwidawsk.net>,
	Tommi Rantala <tt.rantala@gmail.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Dave Jones <davej@redhat.com>
References: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
 <1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
 <20130315045004.GA14747@bwidawsk.net>
 <20130315082403.GA29916@cantiga.alporthouse.com>
 <20130315163606.GA17773@bwidawsk.net>
 <20130315220619.GA17405@cantiga.alporthouse.com>
 <20130315234942.GB715@bwidawsk.net>
 <20130316101920.GB17405@cantiga.alporthouse.com>
 <CAKMK7uFiMLcE_TYj5=sKZsVAcCnWSmg49qPrxjswH2s3J5byOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFiMLcE_TYj5=sKZsVAcCnWSmg49qPrxjswH2s3J5byOg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 08:50:03PM +0100, Daniel Vetter wrote:
> On Sat, Mar 16, 2013 at 11:19 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > If *userspace* doesn't request either IOC_IN | IOC_OUT in their ioctl
> > command (which are seperate from the ioctl number), then kdata is set to
> > NULL.
> 
> Doesn't that mean that we need these checks everywhere? Or at least a
> fixup in drm core proper?

That's my conclusion. We either add a flag to ask drm_ioctl to prevent
passing NULL pointers (as the existing behaviour may be useful
somewhere, and I have not checked all callees) or saturate our callbacks
with NULL checks.
-Chris
-- 
Chris Wilson, Intel Open Source Technology Centre
