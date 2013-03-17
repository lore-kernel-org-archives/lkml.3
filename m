Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3CQWJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 18:09:25 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:57536 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3CQWJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 18:09:19 -0400
Date: Sun, 17 Mar 2013 23:12:03 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/i915: Use the fixed pixel clock for eDP in
 intel_dp_set_m_n()
Message-ID: <20130317221203.GI9021@phenom.ffwll.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1363102348-16337-1-git-send-email-tiwai@suse.de>
 <1363102348-16337-3-git-send-email-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363102348-16337-3-git-send-email-tiwai@suse.de>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 04:32:28PM +0100, Takashi Iwai wrote:
> The eDP output on HP Z1 is still broken when X is started even after
> fixing the infinite link-train loop.  The regression was introduced in
> 3.6 kernel for cleaning up the mode clock handling code in intel_dp.c.
> 
> In the past, the clock of the reference mode was modified in
> intel_dp_mode_fixup() in the case of eDP fixed clock, and this clock was
> used for calculating in intel_dp_set_m_n().  This override was removed,
> thus the wrong mode clock is used for the calculation, resulting in a
> psychedelic smoking output in the end.
> 
> This patch corrects the clock to be used in the place.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

I truly hate this mess of dotclock vs portclock vs. whatever. Can you pls
apply a little bikeshed and use the existing intel_edp_target_clock like
in ironlake_set_m_n? And if you have the regressing commit a little
citation to assign the blame (it's probably me) would be good.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
