Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab3GQOy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:54:26 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:49088 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755888Ab3GQOyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:54:23 -0400
Date: Wed, 17 Jul 2013 07:47:00 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        rockorequin@hotmail.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>, alexkaltsas@gmail.com,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2] drm/i915: fix long-standing SNB regression in power
 consumption after resume
Message-ID: <20130717074700.13d5152e@jbarnes-desktop>
In-Reply-To: <20130717062258.5467.69414.stgit@zurg>
References: <20130714163009.22374.22100.stgit@zurg>
	<20130717062258.5467.69414.stgit@zurg>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 10:22:58 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch fixes regression in power consumtion of sandy bridge gpu, which
> exists since v3.6 Sometimes after resuming from s2ram gpu starts thinking that
> it's extremely busy. After that it never reaches rc6 state.
> 
> Bug exists since kernel v3.6, commit b4ae3f22d238617ca11610b29fde16cf8c0bc6e0
> ("drm/i915: load boot context at driver init time").
> 
> For some reason RC6 is already enabled at the beginning of resuming process.
> Following initliaztion breaks some internal state and confuses RPS engine.
> This patch disables RC6 at the beginnig of resume and initialization.
> 
> I've rearranged initialization sequence, because intel_disable_gt_powersave()
> needs initialized force_wake_get/put and some locks from the dev_priv.
> 
> References: https://bugs.freedesktop.org/show_bug.cgi?id=54089
> References: https://bugzilla.kernel.org/show_bug.cgi?id=58971
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---

My hero!

So the later init change didn't work?

Either way, great to have this fix in the tree... thanks again.

-- 
Jesse Barnes, Intel Open Source Technology Center
