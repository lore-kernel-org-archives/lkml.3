Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222Ab3DKShp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 14:37:45 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:57541 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3DKShn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 14:37:43 -0400
Date: Thu, 11 Apr 2013 20:37:27 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Tomas Melin <tomas.melin@iki.fi>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        stable <stable@vger.kernel.org>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: don't check inconsistent modeset
 state when force-restoring
Message-ID: <20130411183727.GA2649@netboy>
References: <20130409172820.GC27612@phenom.ffwll.local>
 <1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
 <20130410115901.GA4502@netboy>
 <20130410120724.GJ27612@phenom.ffwll.local>
 <20130410172717.GA2480@netboy>
 <CAKMK7uGTqSdq_V=Pu-BGNhhTqOn=fz5-LvUXBXpGQJqzL1QOUQ@mail.gmail.com>
 <20130411175220.GC2482@netboy>
 <CAKMK7uFVpnbxT-P+eEoFjKPJ1bEom7Q_PhNcr1ZnzApkc8mqug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFVpnbxT-P+eEoFjKPJ1bEom7Q_PhNcr1ZnzApkc8mqug@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 08:14:10PM +0200, Daniel Vetter wrote:
> 
> I've just tracked down and fixed an bug which can lead to a hard-hang
> in the crtc restore code (which is used both in the lid handler when
> opening and on resume). If you could please test this patch (on top of
> drm-intel-nightly):
> 
> https://patchwork.kernel.org/patch/2428971/

Okay, will do.

> >> I'll quickly port the patch (in it's latest v3 version) to 3.9-rc
> >> kernels for you to test.

FWIW, this does work, no freeze, no warning, but instead:

Apr 11 20:30:49 netboy laptop-mode: Laptop mode 
Apr 11 20:30:49 netboy laptop-mode: enabled, 
Apr 11 20:30:49 netboy laptop-mode: not active [unchanged]
Apr 11 20:30:53 netboy kernel: [   75.450783] [drm:i9xx_crtc_mode_set] *ERROR* Couldn't find PLL settings for mode!
Apr 11 20:30:53 netboy laptop-mode: Laptop mode 
Apr 11 20:30:53 netboy laptop-mode: enabled, 
Apr 11 20:30:53 netboy laptop-mode: not active [unchanged]

Thanks,
Richard
