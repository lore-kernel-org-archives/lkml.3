Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3JXMRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:17:16 -0400
Received: from server109-228-6-235.live-servers.net ([109.228.6.235]:15176
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754355Ab3JXMRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:17:15 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Thu, 24 Oct 2013 13:17:06 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        fei.li@intel.com
Subject: Re: drm/i915: Avoid accessing the stolen address when it is
 unavailable
Message-ID: <20131024121706.GB3233@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Chuansheng Liu <chuansheng.liu@intel.com>, daniel.vetter@ffwll.ch,
	airlied@linux.ie, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	fei.li@Intel.com
References: <1382632427.26153.94.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382632427.26153.94.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 12:33:47AM +0800, Chuansheng Liu wrote:
> 
> In our platform, we hit the the stolen region initialization failure case,
> such as below log:
> [drm:i915_stolen_to_physical] *ERROR* conflict detected with stolen region: [0x7b000000]
> 
> And it causes the dev_priv->mm.stolen_base is NULL, in this case, we should
> avoid accessing it any more.
> 
> Here is possible call trace:
> intel_enable_gt_powersave -- >
> valleyview_enable_rps -- >
> valleyview_setup_pctx

The two create_stolen routines are no-ops in that case so all that
happens instead is that we read VLV_PCBR. However, really if
i915_gem_object_create_stolen_for_preallocated() fails we should abort
loading the driver as it means we have a hardware conflict and undefined
behaviour.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
