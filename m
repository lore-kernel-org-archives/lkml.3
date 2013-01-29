Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab3A2Jvq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:51:46 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:48717 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab3A2Jvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:51:44 -0500
Date: Tue, 29 Jan 2013 10:53:50 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Bernhard Wiedemann <bwiedemann@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/cirrus: Add bpp option
Message-ID: <20130129095350.GI14766@phenom.ffwll.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	Bernhard Wiedemann <bwiedemann@suse.com>,
	linux-kernel@vger.kernel.org
References: <1359130915-30082-1-git-send-email-tiwai@suse.de>
 <1359130915-30082-2-git-send-email-tiwai@suse.de>
 <s5htxq0s882.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htxq0s882.wl%tiwai@suse.de>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 09:29:17AM +0100, Takashi Iwai wrote:
> Add a new option, bpp, to specify the default bpp value.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> 
> This patch is applied on the top of previous two patches.
> I couldn't find an easy way to specify the default bpp, so I cooked
> the driver quickly.  If there is any other convenient way to achieve
> this, let me know...

Well, you can specify the desired bpp with a full mode on the kernel
cmdline - the '-bpp' extension. Reading through the parser I think it
should work even with just the '-bpp' and not a full mode, but I haven't
tested. Look for cmdline_mode->bpp_specified in drm_fb_helper.c and the
relevant parsing code in drm_mode_parse_command_line_for_connector in
drm_modes.c

If that doesn't work for you, I think it's better to extend/fix it than
add driver module options.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
